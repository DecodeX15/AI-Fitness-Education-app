import json
import numpy as np
import onnxruntime as ort
from transformers import AutoTokenizer

tokenizer = AutoTokenizer.from_pretrained("minilm_model")

session = ort.InferenceSession("onnx_model/model.onnx")

def embed(text):
    inputs = tokenizer(text, return_tensors="np")
    inputs.pop("token_type_ids", None)
    outputs = session.run(None, inputs)
    token_embeddings = outputs[0]
    sentence_embedding = token_embeddings.mean(axis=1)[0]
    return sentence_embedding

def cosine_similarity(a, b):
    return np.dot(a, b) / (np.linalg.norm(a) * np.linalg.norm(b))

with open("tag_embeddings.json") as f:
    tag_db = json.load(f)

user_text = input("Enter user text: ")

user_vec = embed(user_text)

results = {}

TOP_K = 2

for category in tag_db:
    scores = []

    for item in tag_db[category]:
        tag_vec = np.array(item["embedding"])
        score = cosine_similarity(user_vec, tag_vec)

        scores.append((item["tag"], score))

    scores.sort(key=lambda x: x[1], reverse=True)

    results[category] = scores[:TOP_K]

print("\nDetected tags:")
for k, v in results.items():
    print(k, "->", v)
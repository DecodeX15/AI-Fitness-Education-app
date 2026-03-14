import json
import numpy as np
import onnxruntime as ort
from transformers import AutoTokenizer

tokenizer = AutoTokenizer.from_pretrained("minilm_model")
session = ort.InferenceSession("../assets/model.onnx")

def embed(text):
    inputs = tokenizer(text, return_tensors="np")
    inputs.pop("token_type_ids", None)
    outputs = session.run(None, inputs)
    token_embeddings = outputs[0]
    sentence_embedding = token_embeddings.mean(axis=1)[0]
    return sentence_embedding.tolist()

with open("../assets/tags_db.json") as f:
    tags = json.load(f)

result = {}

for category, items in tags.items():
    result[category] = []
    for tag in items:
        result[category].append({
            "tag": tag,
            "embedding": embed(tag)
        })

with open("../assets/tag_embeddings.json", "w") as f:
    json.dump(result, f, indent=2)

print("Tag embeddings generated successfully")
from sentence_transformers import SentenceTransformer

model = SentenceTransformer("sentence-transformers/all-MiniLM-L6-v2")

model.save("minilm_model")

print("Model downloaded and saved.")
import onnxruntime as ort
from transformers import AutoTokenizer
import numpy as np

tokenizer = AutoTokenizer.from_pretrained("minilm_model")
session = ort.InferenceSession("onnx_model/model.onnx")
text = "I want exercises for chest"
inputs = tokenizer(text, return_tensors="np")
inputs.pop("token_type_ids", None)
outputs = session.run(None, inputs)
embedding = outputs[0]
print("Embedding shape:", embedding.shape)
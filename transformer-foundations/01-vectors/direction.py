import torch

a = torch.tensor([3.0, 4.0])
b = torch.tensor([6.0, 8.0])
c = torch.tensor([30.0, 40.0])

print("a:", a, "magnitude:", torch.linalg.vector_norm(a))
print("b:", b, "magnitude:", torch.linalg.vector_norm(b))
print("c:", c, "magnitude:", torch.linalg.vector_norm(c))

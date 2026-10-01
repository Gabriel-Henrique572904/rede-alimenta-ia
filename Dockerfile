# 1. Imagem base leve (slim) para reduzir superfície de ataque
FROM python:3.10-slim

# 2. Otimizações do Python
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# 3. Diretório de trabalho
WORKDIR /app

# 4. Atualizar pacotes de sistema base (Segurança)
RUN apt-get update && apt-get upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 5. Criar utilizador sem privilégios (Mitigação de Elevation of Privilege)
RUN adduser --disabled-password --gecos "" redeuser && chown -R redeuser /app

# 6. Instalar dependências
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# 7. Copiar o notebook e o dataset para dentro do contentor
COPY RedeAlimenta_IA_Checkpoint1_2.ipynb .
COPY Consolidated_Supermarket_Data.csv .

# 8. Mudar para o utilizador restrito
USER redeuser

# 9. Expor porta (preparação para a API)
EXPOSE 8000

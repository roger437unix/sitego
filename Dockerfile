FROM golang:1.24rc1-alpine3.21 as stage1

WORKDIR /app

# Copia o go.mod e faz o download das dependências
COPY go.mod ./
RUN go mod download

# Copia o código da aplicação e compila o binário
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o meuExecutavel

# Estágio 2: Copiar a imagem do stage anterior para a imagem final
FROM scratch

WORKDIR /

# Copia apenas o binário gerado no stage anterior
COPY --from=stage1 /app/meuExecutavel /
COPY --from=stage1 /app/templates /templates
EXPOSE 8000
# Define o ponto de entrada para o container como /meuExecutavel
# O binário será executado quando o container for iniciado
ENTRYPOINT [ "/meuExecutavel" ]

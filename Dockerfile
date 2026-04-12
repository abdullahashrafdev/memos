# Build frontend
FROM node:20-alpine AS frontend
WORKDIR /web
COPY web/package*.json ./
RUN npm install --legacy-peer-deps
COPY web/ .
RUN npm run build

# Build backend with embedded frontend
FROM golang:1.26-alpine AS backend
WORKDIR /build
COPY . .
COPY --from=frontend /web/dist ./server/router/frontend/dist
RUN go build -o memos ./cmd/memos/main.go

# Final image
FROM alpine:latest
WORKDIR /app
COPY --from=backend /build/memos .
EXPOSE 5230
CMD ["./memos", "--port", "5230", "--data", "/var/opt/memos"]
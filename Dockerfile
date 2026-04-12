# Build stage
FROM golang:1.26-alpine AS builder
WORKDIR /build
COPY . .
RUN go build -o memos ./cmd/memos/main.go

# Run stage
FROM alpine:latest
WORKDIR /app
COPY --from=builder /build/memos .
EXPOSE 5230
CMD ["./memos"]
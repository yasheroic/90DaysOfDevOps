# Build Stage

FROM node:20-slim AS builder

WORKDIR /app 

RUN apt-get update && apt-get install -y openssl

COPY package*.json .

RUN npm ci 

COPY . .

RUN npx prisma generate

RUN npm run build

# Production Stage

FROM node:20-slim

WORKDIR /app

RUN apt-get update && apt-get install -y openssl

COPY package*.json .

COPY --from=builder /app/prisma ./prisma


RUN npm ci --omit=dev

RUN npx prisma generate

COPY --from=builder /app/.next ./.next

COPY --from=builder /app/public ./public

COPY --from=builder /app/scripts ./scripts

RUN chmod +x ./scripts/health-check-build.sh 

EXPOSE 3000

CMD ["sh", "-c", "npx prisma migrate deploy && npm start"]
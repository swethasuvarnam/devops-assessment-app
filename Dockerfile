FROM node:18-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm install --frozen-lockfile

COPY . .
RUN npm run build

FROM node:18-alpine AS runner
WORKDIR /app

COPY --from=builder /app/package*.json ./
RUN npm install --production --frozen-lockfile

COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public


EXPOSE 3000
CMD ["npx", "next", "start", "-p", "3000"]



FROM node:lts-alpine3.22 AS builder

RUN corepack enable

WORKDIR /app

COPY package.json pnpm-lock.yaml ./

RUN pnpm install --frozen-lockfile

COPY . .

RUN pnpm build


FROM node:lts-alpine3.22 AS runner

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

COPY --from=builder /app ./

USER appuser

EXPOSE 3000

CMD ["pnpm", "start"]
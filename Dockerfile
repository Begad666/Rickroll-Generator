FROM oven/bun:1.2-alpine AS base
ENV NODE_ENV=production
WORKDIR /app
COPY package.json bun.lock ./

FROM base AS build
COPY . .
RUN bun install --frozen-lockfile
RUN bun run build

FROM base AS run
RUN bun install --frozen-lockfile --production
COPY .env ./
COPY --from=build /app/built ./built
COPY --from=build /app/public ./public
COPY --from=build /app/views ./views

CMD ["bun", "."]

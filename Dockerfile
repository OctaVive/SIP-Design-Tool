FROM oven/bun:1-alpine AS build

WORKDIR /app

COPY package.json bun.lock ./
RUN bun install --frozen-lockfile

COPY index.html vite.config.ts tsconfig.json metadata.json ./
COPY src ./src

RUN bun run build

FROM nginx:1.27-alpine AS production

COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

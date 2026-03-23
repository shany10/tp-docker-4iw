FROM node:20-bookworm-slim AS build

WORKDIR /app

COPY package*.json ./
RUN if [ -f package-lock.json ]; then npm ci; else npm install; fi

COPY . .
RUN npm run build


FROM node:20-bookworm-slim AS runtime

ENV NODE_ENV=production
WORKDIR /app

COPY package*.json ./
RUN if [ -f package-lock.json ]; then npm ci --omit=dev; else npm install --omit=dev; fi && npm cache clean --force

COPY --from=build /app/dist ./dist
COPY --from=build /app/server.cjs ./server.cjs

RUN chown -R node:node /app
USER node

EXPOSE 8080

CMD ["node", "server.cjs"]

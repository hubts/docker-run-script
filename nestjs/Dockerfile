# Builder
FROM node:16.18 AS builder
WORKDIR /build

COPY    package.json yarn.lock ./
COPY    nest-cli.json tsconfig.build.json tsconfig.json ./
COPY    src ./src

RUN     yarn install --pure-lockfile --production
RUN     yarn add --dev @nestjs/cli
RUN     yarn build

# Distribute
FROM node:16.18-alpine
LABEL maintainer "@hubts <gtsk623@gmail.com>"
WORKDIR /app

COPY    --from=builder /build/dist          ./dist
COPY    --from=builder /build/package.json  ./package.json
COPY    --from=builder /build/node_modules  ./node_modules

# Run
CMD ["yarn", "start:prod"]
FROM alpine
ENV PATH="${PATH}:/app"
WORKDIR /app
COPY gpm.sh /app/gpm
RUN apk add bash \
  && chmod +x /app/gpm

FROM pytorch/pytorch:1.12.1-cuda11.3-cudnn8-runtime
WORKDIR /opt/wsi-classification
COPY . .
RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc git libopenslide0 \
    && python -m pip install --no-cache-dir --editable . \
        --find-links https://girder.github.io/large_image_wheels \
    && apt-get autoremove --yes gcc \
    && rm -rf /var/lib/apt/lists/*
# Use a writable directory for downloading model weights. Default is ~/.cache, which is
# not guaranteed to be writable in a Docker container.
ENV TORCH_HOME=/var/lib/wsi_inference
RUN mkdir -p "$TORCH_HOME" \
    && chmod 777 "$TORCH_HOME" \
    && chmod a+s "$TORCH_HOME"
WORKDIR /work
ENTRYPOINT ["wsi_run"]
LABEL maintainer="Jakub Kaczmarzyk <jakub.kaczmarzyk@stonybrookmedicine.edu>"

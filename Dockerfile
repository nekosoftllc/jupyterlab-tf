# A Dockerfile for using Jupyter Lab with Tensorflow and BigQuery

# https://hub.docker.com/r/nekosoft/tensorflow-notebook

# How to run
# ==========
# docker run -it --name jupyterlab-tf -p 8888:8888 -e JUPYTER_ENABLE_LAB=yes nekosoft/tensorflow-notebook

ARG BASE_CONTAINER=jupyter/tensorflow-notebook
FROM $BASE_CONTAINER

RUN conda install --quiet --yes \
    'jupyterlab-git==0.23.3' \
    'google-cloud-bigquery[pandas]' && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER
RUN jupyter lab build --dev-build=False --minimize=False

# Install Cloud SDK
USER root
RUN apt-get update -y && apt-get install curl gnupg -y
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" \
    | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg \
    | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - \
    && apt-get update -y && apt-get install google-cloud-sdk -y
    
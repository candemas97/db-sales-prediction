FROM python:3.9
COPY ./requirements.txt /requirements.txt
RUN pip install --upgrade pip
RUN pip install jupyter==1.0.0 -U && pip install jupyterlab==3.6.1
RUN pip install -r requirements.txt
# EXPOSE 8088
ENTRYPOINT ["jupyter", "lab","--ip=0.0.0.0","--allow-root", "--port", "8088"]

sudo apt install nginx
sudo cp boilerplate/flask_app /etc/nginx/sites-enabled/flask_app
sudo cp boilerplate/.bash_profile ~/.bash_profile
sudo unlink /etc/nginx/sites-enabled/default
sudo nginx -s reload
sudo apt install python3
sudo apt install python3-pip
pip3 install -r requirements.txt
sudo apt install gunicorn3
sudo apt install tmux
pip install notebook
pip3 install jupyterlab
jupyter notebook --generate-config
sudo cp boilerplate/jupyter_notebook_config.py ~/.jupyter/jupyter_notebook_config.py
sudo cp boilerplate/jupyter_server_config.json ~/.jupyter/jupyter_server_config.json
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo -i -u postgres
createuser omni
createdb truthriver
psql -c "ALTER USER omni WITH PASSWORD 'planttheknowledgetree';"
psql -c "GRANT ALL PRIVILEGES ON DATABASE truthriver TO omni;"
exit
sudo cp boilerplate/postgresql.conf /etc/postgresql/13/main/postgresql.conf
sudo cp boilerplate/pg_hba.conf /etc/postgresql/13/main/pg_hba.conf
sudo systemctl reload postgresql@13-main

source ~/.bash_profile
tmux new-session -s lab -d 'jupyter lab \
  --port=8080 \
  --NotebookApp.port_retries=0 \
  --allow-root'
tmux new-session -s prod -d "gunicorn3 --workers=3 --bind 0.0.0.0:8000 --timeout 60000 routes:app"'


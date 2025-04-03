sudo apt update -y
sudo apt upgrade -y  # Automatically upgrades packages without user interaction
sudo apt install -y nginx python3 python3-pip python3-venv tmux
sudo cp boilerplate/flask_app /etc/nginx/sites-enabled/flask_app
sudo cp boilerplate/.bash_profile ~/.bash_profile
sudo unlink /etc/nginx/sites-enabled/default
sudo nginx -s reload

# Create and activate virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies in virtual environment
pip install --upgrade pip
pip install -r requirements.txt
pip install notebook jupyterlab gunicorn

# Configure Jupyter
jupyter notebook --generate-config
sudo cp boilerplate/jupyter_notebook_config.py ~/.jupyter/jupyter_notebook_config.py
sudo cp boilerplate/jupyter_server_config.json ~/.jupyter/jupyter_server_config.json

# PostgreSQL setup - commented out for now
# sudo apt install -y postgresql postgresql-contrib
# sudo -i -u postgres << EOF
# createuser omni
# createdb truthriver
# psql -c "ALTER USER omni WITH PASSWORD 'planttheknowledgetree';"
# psql -c "GRANT ALL PRIVILEGES ON DATABASE truthriver TO omni;"
# EOF

# sudo cp boilerplate/postgresql.conf /etc/postgresql/13/main/postgresql.conf
# sudo cp boilerplate/pg_hba.conf /etc/postgresql/13/main/pg_hba.conf
# sudo systemctl reload postgresql@13-main

source ~/.bash_profile

# Start services using virtual environment python
tmux new-session -s lab -d ". venv/bin/activate && jupyter lab \
  --port=8080 \
  --NotebookApp.port_retries=0 \
  --allow-root"
tmux new-session -s prod -d ". venv/bin/activate && gunicorn --workers=3 --bind 0.0.0.0:8000 --timeout 60000 routes:app"

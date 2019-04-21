pip3 install -r requirements.txt

cd server/

export FLASK_APP=api.py

flask run --host=0.0.0.0

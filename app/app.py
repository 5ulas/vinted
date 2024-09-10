from flask import Flask, redirect, url_for, session
from authlib.integrations.flask_client import OAuth
from dotenv import load_dotenv
import os, uuid

load_dotenv()

app = Flask(__name__)

app.secret_key = os.getenv('FLASK_SECRET_KEY')

oauth = OAuth(app)

okta = oauth.register(
    name='okta',
    client_id=os.getenv('OKTA_CLIENT_ID'),
    client_secret=os.getenv('OKTA_CLIENT_SECRET'),
    server_metadata_url=os.getenv('OKTA_METADATA_URL'),
    client_kwargs={
        'scope': 'openid profile email'
    }
)

@app.route('/')
def index():
    return '<h1>Laurynas App</h1><a href="/login">Login with Okta</a>'

@app.route('/login')
def login():
    nonce = str(uuid.uuid4())
    session['nonce'] = nonce 
    redirect_uri = url_for('callback', _external=True)
    return okta.authorize_redirect(redirect_uri, nonce=nonce)

@app.route('/callback')
def callback():
    token = okta.authorize_access_token()
    nonce = session.pop('nonce')
    user_info = okta.parse_id_token(token, nonce=nonce)
    session['user'] = user_info
    return redirect(url_for('profile'))

@app.route('/profile')
def profile():
    user = session.get('user')
    if user:
        return f'<h1>Hello {user["name"]} ({user["email"]})</h1>'
    return redirect(url_for('login'))

@app.route('/logout')
def logout():
    session.pop('user', None)
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=3000, debug=True)
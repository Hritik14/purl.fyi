from flask import Flask
from flask import abort
from flask import redirect
from flask import render_template
from flask import request
from packageurl.contrib import purl2url

app = Flask(__name__)


@app.route("/")
def home():
    purl = request.args.get("purl")
    if purl:
        return redirect(f"/{purl}")
    return render_template("home.html")


@app.route("/info/<path:path>")
def info(path):
    return "More info coming"


@app.route("/<path:purl>")
def url(purl):
    url = purl2url.get_repo_url(purl)
    if url:
        return redirect(url)
    else:
        return abort(501)  # Show want to implement link

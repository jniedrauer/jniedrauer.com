from flask import Flask, session, g, render_template

app = Flask(__name__)
app.config.from_object('flask_config')

@app.errorhandler(404)
def not_found(error):
    return render_template('404.html'), 404

@app.route("/")
def main():
    index_path = os.path.join(app.static_folder, 'index.html')
    return send_file(index_path)

if __name__ == '__main__':
    # Debugging use only
    app.run(host='0.0.0.0', debug=True, port=8080)

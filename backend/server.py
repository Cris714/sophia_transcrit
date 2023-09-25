import assemblyai as aai
import openai
import os

from flask import Flask, flash, request, redirect, url_for
from werkzeug.utils import secure_filename

import nlp_model



# AJUSTES INICIALES

aai.settings.api_key = "2aac2208b8f84b578abb6ba7cc245175"
openai.api_key = "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"

UPLOAD_TEXT_FOLDER = 'temp_text'
UPLOAD_AUDIO_FOLDER = 'temp_audio'
ALLOWED_EXTENSIONS_AUDIO = {'m4a', 'mp3', 'webm', 'mp4', 'mpga', 'wav', 'mpeg'}
ALLOWED_EXTENSIONS_TEXT = {'txt'}

app = Flask(__name__) 
app.config['UPLOAD_TEXT_FOLDER'] = UPLOAD_TEXT_FOLDER
app.config['UPLOAD_AUDIO_FOLDER'] = UPLOAD_AUDIO_FOLDER
app.config['MAX_CONTENT_LENGTH'] = 16 * 1000 * 1000
app.config['SESSION_TYPE'] = 'filesystem'
app.secret_key = 'super secret key'

#####################################################################################

def allowed_file_audio(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS_AUDIO

def allowed_file_text(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS_TEXT

#####################################################################################

@app.route('/text', methods=['POST'])
def upload_text():
    if request.method == 'POST':
        # check if the post request has the file part
        if 'text' not in request.files:
            flash('No file part')
        
        file = request.files['text']
        # If the user does not select a file, the browser submits an
        # empty file without a filename.
        if file.filename == '':
            flash('No selected file')
            
        if file and allowed_file_text(file.filename):
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config['UPLOAD_TEXT_FOLDER'], filename))
            
    return ''

@app.route('/audio', methods=['POST'])
def upload_audio():
    if request.method == 'POST':
        # check if the post request has the file part
        if 'audio' not in request.files:
            flash('No file part')
        
        file = request.files['audio']
        # If the user does not select a file, the browser submits an
        # empty file without a filename.
        if file.filename == '':
            flash('No selected file')
            
        if file and allowed_file_audio(file.filename):
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config['UPLOAD_AUDIO_FOLDER'], filename))

    return ''

# TRANSCRIPCION

transcriber = aai.Transcriber()

@app.route('/transcript', methods=['GET'])
def transcribe():
    # Especifica la ruta del archivo MP3
    file_path = f"temp_audio\{request.args['File']}"

    try:
        with open(file_path, "rb") as audio_file:
             transcript = openai.Audio.transcribe(
                file=audio_file,
                model="whisper-1",
                response_format="text",
                language="es"
            )
        
        print(" *** TRANSCRITO CON WHISPER ***")

        # Remove the temporary file after transcription
        os.remove(file_path)

        return transcript
    
    except Exception as e:
        print(" *** TRANSCRITO CON ASS ***")
        print(str(e))

        transcript = transcriber.transcribe(file_path)

        # Remove the temporary file after transcription
        os.remove(file_path)
        
        return transcript.text

#####################################################################################

# PROCESAMIENTO DE TEXTO

@app.route('/process', methods=['GET'])
def process():
    keywords = request.args['kw'] == 'true'
    summarize = request.args['sm'] == 'true'

    file_path = f"temp_text\{request.args['File']}"

    try:
        with open(file_path) as f:
            text = f.read()

        response = ''

        if keywords:
            kw_response = openai.ChatCompletion.create(
                model="gpt-3.5-turbo",
                messages=[
                    {
                    "role": "system",
                    "content": "Obten las palabras clave del siguiente texto."
                    },
                    {
                    "role": "user",
                    "content": text
                    }
                ],
                temperature=0,
                max_tokens=64,
                top_p=1,
                frequency_penalty=0,
                presence_penalty=0
                )
            
            response += '    - Key words\n\n' + kw_response['choices'][0]['message']['content'] + '\n\n\n'

        if summarize:
            sm_response = openai.ChatCompletion.create(
                model="gpt-3.5-turbo",
                messages=[
                    {
                    "role": "system",
                    "content": "Resume muy brevemente el siguiente texto."
                    },
                    {
                    "role": "user",
                    "content": text
                    }
                ],
                temperature=0,
                max_tokens=64,
                top_p=1,
                frequency_penalty=0,
                presence_penalty=0
                )
            
            response += '    - Summary\n\n' + sm_response['choices'][0]['message']['content'] + '\n\n'
        
        os.remove(file_path)
        
        print(" *** PROCESADO CON GPT ***")

        return response

    except:
        print(" *** PROCESADO CON T5 ***")

        response = ''

        if keywords:
            kw_response = nlp_model.key_words(f'temp_text/{request.args["File"]}')
            response += '    - Key words\n\n' + kw_response + '\n\n\n'

        if summarize:
            sm_response = nlp_model.summarize(f'temp_text/{request.args["File"]}')
            response += '    - Summary\n\n' + sm_response + '\n\n'

        os.remove(file_path)

        return response

#####################################################################################

if __name__ == '__main__':
	app.run(host='0.0.0.0', port=8000)

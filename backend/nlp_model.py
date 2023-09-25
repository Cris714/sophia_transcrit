from transformers import AutoTokenizer, AutoModelWithLMHead

tokenizer = AutoTokenizer.from_pretrained('t5-base')
model = AutoModelWithLMHead.from_pretrained('t5-base', return_dict=True)

def summarize(filename):
    with open(filename) as f:
        inputs = tokenizer.encode("summarize: " + ''.join(f.readlines()),
            return_tensors='pt',
            max_length=1024,
            truncation=True)

        summary_ids = model.generate(inputs, max_length=10000, min_length=1, length_penalty=5., num_beams=2)

        return tokenizer.decode(summary_ids[0])
    
def key_words(filename):
    with open(filename) as f:
        inputs = tokenizer.encode("key words: " + ''.join(f.readlines()),
            return_tensors='pt',
            max_length=1024,
            truncation=True)

        summary_ids = model.generate(inputs, max_length=128, min_length=1, length_penalty=5., num_beams=2)

        return tokenizer.decode(summary_ids[0])
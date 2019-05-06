import requests
import json
addr = 'http://52.163.230.167:5000'
test_get = addr + '/v1/api/test_get'
test_post = addr + '/v1/api/summarize'
summarizing = "http://52.163.230.167:5000/v1/api/summarize"
question_answering = "http://52.163.230.167:5000/v1/api/answer_question"

# # request summarizing API
# payload = {
# "articleContent": "Air pollution is one of the most dangerous forms of pollution. A biological, chemical, and physical alteration of the air occurs when smoke, dust, and any harmful gases enter into the atmosphere and make it difficult for all living beings to survive as the air becomes contaminated. Burning of fossil fuels, agriculture related activities, mining operations, exhaust from industries and factories, and household cleaning products entail air pollution. People release a huge amount of chemical substances in the air every day. The effects of air pollution are alarming. It causes global warming, acid rains, respiratory and heart problems, and eutrophication. A lot of wildlife species are forced to change their habitat in order to survive. Soil pollution occurs when the presence of pollutants, contaminants, and toxic chemicals in the soil is in high concentration that has negative effect on wildlife, plants, humans, and ground water. Industrial activity, waste disposal, agricultural activities, acid rain, and accidental oil spill are the main causes of soil pollution. This type of contamination influence health of humans, affects the growth of plants, decreases soil fertility, and changes the soil structure. Water pollution is able to lead our world on a path of destruction. Water is one of the greatest natural resources of the whole humanity. Nothing will be able to live without water. However, we do not appreciate this gift of nature and pollute it without thinking. The key causes of the water pollution are: industrial waste, mining activities, sewage and waste water, accidental oil leakage, marine dumping, chemical pesticides and fertilizers, burning of fossil fuels, animal waste, urban development, global warming, radioactive waste, and leakage from sewer lines. There is less water available for drinking, cooking, irrigating crops, and washing.",
# }
# payload = json.dumps(payload)
# loaded_payload = json.loads(payload)
# post_response = requests.post(summarizing, '', json=loaded_payload)
# res = post_response.json()
# print('Response of POST method: ' + str(res) )

#request question answering API
payload2 = {
"question": "What are the main reasons of water pollution?",
"hash_url": "C5B5300ECED62665ACC6CA32A0BEB39AE942B861"
}
payload2 = json.dumps(payload2)
loaded_payload2 = json.loads(payload2)

counter = 0
for i in range (1,1000): 
    post_response = requests.post(question_answering, '', json=loaded_payload2)
    res = post_response.json()
    print('Response of POST method: ' + str(res) )
    counter = counter + 1 
    print(counter)
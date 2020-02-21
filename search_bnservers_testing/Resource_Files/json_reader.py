import json

class json_reader:
    def get_values(self, response, key):
        '''load json list object to a python object and extract the required values'''
        key_list = []
        data=json.loads(response)
        
        for obj in data:
            key_list.append(obj[key])
        return key_list

    def filter_archived_entities(self, response):
        '''load response json object and filter archived data'''
        filtered_response = []
        data = json.loads(response)

        for obj in data:
             if obj['state']!="archived":
                filtered_response.append(obj)
        updated_response = json.dumps(filtered_response)
        return updated_response
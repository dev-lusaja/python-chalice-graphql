import json

from chalice import Chalice
from graphene import ObjectType, String, Schema

app = Chalice(app_name='chalice_app')

class Query(ObjectType):
    hello = String()

    @staticmethod
    def resolve_hello(self, info):
        return 'world'

class Mutation(ObjectType):
    bye = String()

    @staticmethod
    def resolve_bye(self, info):
        return 'world'

schema = Schema(
    query=Query,
    mutation=Mutation
)

@app.route('/graphql', methods=['POST'])
def name():
    query = json.loads(app.current_request.raw_body.decode())['query']
    result = schema.execute(query)
    return result.data

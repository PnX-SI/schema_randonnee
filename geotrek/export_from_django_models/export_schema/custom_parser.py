from geotrek.common.parsers import Parser
from geotrek.trekking.models import POIType


class SerializerSchemaItinerairesRando(Parser):
    url = 'just_so_its_not_none'
    model = POIType  # Useless but shouldn't be None

    def parse(self, filename=None, limit=None):
        import importlib
        from os.path import join

        from django.conf import settings

        # Execute export_schema/export.py as an imported module
        module_path = join(settings.VAR_DIR, 'conf/export_schema/export.py')
        spec = importlib.util.spec_from_file_location("export", module_path)
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)

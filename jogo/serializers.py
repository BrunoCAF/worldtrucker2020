# serializers.py
from rest_framework import serializers

from .models import ScoreEntry

class ScoreSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = ScoreEntry
        fields = ('username', 'userid', 'conclusionTime', 'ghostInfo')
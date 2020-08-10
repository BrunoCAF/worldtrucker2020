# serializers.py
from rest_framework import serializers

from .models import ScoreEntry

class ScoreSerializer(serializers.JSONField):
    class Meta:
        model = ScoreEntry
        fields = ('username', 'userid', 'conclusionTime', 'ghost')
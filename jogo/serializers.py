# serializers.py
from rest_framework import serializers

from .models import ScoreEntry

class GhostSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = ScoreEntry
        fields = ('username', 'ghostInfo')


class RankSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = ScoreEntry
        fields = ('username', 'conclusionTime')


class ScoreSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = ScoreEntry
        fields = ('username', 'userid', 'conclusionTime', 'ghostInfo')



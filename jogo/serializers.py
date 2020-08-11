# serializers.py
from rest_framework import serializers

from .models import ScoreEntry

class RankedScoreEntry(ScoreEntry):
    def __init__(self, rank, score_entry):
        self.username = score_entry.username
        self.conclusionTime = score_entry.conclusionTime
        self.rank = rank        
    
    def __str__(self):
        return f"#{self.rank} {self.username}: {self.conclusionTime}"


class RankSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = ScoreEntry
        fields = ('username', 'conclusionTime')


class ScoreSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = ScoreEntry
        fields = ('username', 'userid', 'conclusionTime', 'ghostInfo')



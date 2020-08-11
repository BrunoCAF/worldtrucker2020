from django.shortcuts import render
from django.http import HttpResponse, HttpRequest

# Create your views here.

from rest_framework import viewsets

from .serializers import ScoreSerializer, RankSerializer
from .models import ScoreEntry
from rest_framework.decorators import action
from rest_framework.response import Response

def home(request):
    return HttpResponse("World Trucker 2020")

class ScoreViewSet(viewsets.ModelViewSet):
    queryset = ScoreEntry.objects.all().order_by('conclusionTime')
    serializer_class = ScoreSerializer


class TopScoresViewSet(viewsets.ModelViewSet):
    lastindex = min(100, ScoreEntry.objects.count())
    queryset = ScoreEntry.objects.get_queryset().order_by('conclusionTime')[:lastindex].only('username', 'conclusionTime')
    serializer_class = RankSerializer


class GlobalScoresViewSet(viewsets.ModelViewSet):
    queryset = ScoreEntry.objects.order_by('conclusionTime').only('username', 'conclusionTime')
    serializer_class = ScoreSerializer
    lookup_field = 'userid'

    @action(detail=True)
    def around(self, request, userid, pk=None):
        entry = self.queryset.filter(userid=userid).get()
        acima = self.queryset.filter(conclusionTime__lt=entry.conclusionTime)
        abaixo = self.queryset.filter(conclusionTime__gt=entry.conclusionTime)
        qtd_acima, qtd_abaixo = min(len(acima), 2), min(len(abaixo), 2)
        tempoacima = acima[len(acima)-qtd_acima].conclusionTime
        tempoabaixo = abaixo[qtd_abaixo].conclusionTime
        maiorRank = self.queryset.filter(conclusionTime__lte=tempoacima).count()
        qs = self.queryset.filter(conclusionTime__gte=tempoacima, conclusionTime__lt=tempoabaixo)        
        return Response({"rank":maiorRank, "data":RankSerializer(qs, many=True).data})


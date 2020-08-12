from django.shortcuts import render
from django.http import HttpResponse, HttpRequest

# Create your views here.

from rest_framework import viewsets

from .serializers import ScoreSerializer, RankSerializer, GhostSerializer
from .models import ScoreEntry
from rest_framework.decorators import action
from rest_framework.response import Response
from django.views.decorators.csrf import csrf_exempt
import json
import uuid

def gerarUUID(request):
    userid = uuid.uuid4()
    ScoreEntry.objects.create(username="", userid=userid, conclusionTime=-1, ghostInfo="")
    return HttpResponse(userid)

@csrf_exempt
def submitScore(request):
    print("TÉCNICA DE DEPURAÇÃO AVANÇADA")
    print(json.loads(request.body.decode()))
    print("TÉCNICA DE DEPURAÇÃO AVANÇADA")
    dicio = json.loads(request.body.decode())
    name, userid = dicio["username"], dicio["userid"]
    time, ghost = dicio["conclusionTime"], dicio["ghostInfo"]
    ScoreEntry.objects.filter(userid=userid).update(username=name, conclusionTime=time, ghostInfo=ghost)
    return HttpResponse("deu certo sim, pode confiar")


def ghost(request):
    rank = int(request.GET["rank"])
    entry = ScoreEntry.objects.filter(conclusionTime__gt=0).order_by("conclusionTime").all()[rank-1]
    return HttpResponse(entry.ghostInfo)


class ScoreViewSet(viewsets.ModelViewSet):
    queryset = ScoreEntry.objects.all().order_by('conclusionTime')
    serializer_class = ScoreSerializer


class TopScoresViewSet(viewsets.ModelViewSet):
    lastindex = min(100, ScoreEntry.objects.count())
    queryset = ScoreEntry.objects.get_queryset().order_by('conclusionTime').filter(conclusionTime__gt=0)[:lastindex].only('username', 'conclusionTime')
    serializer_class = RankSerializer


class GlobalScoresViewSet(viewsets.ModelViewSet):
    queryset = ScoreEntry.objects.order_by('conclusionTime').only('username', 'conclusionTime')
    serializer_class = ScoreSerializer
    lookup_field = 'userid'
    #print('')

    @action(detail=True)
    def around(self, request, userid, pk=None):
        entry = self.queryset.filter(userid=userid).get()
        if entry.conclusionTime < 0: 
            lastindex = min(100, ScoreEntry.objects.count())
            qs = ScoreEntry.objects.get_queryset().order_by('conclusionTime').filter(conclusionTime__gt=0)[:lastindex].only('username', 'conclusionTime')
            maiorRank = 1
            return Response({"rank":maiorRank, "data":RankSerializer(qs, many=True).data})
        
        acima = self.queryset.filter(conclusionTime__lt=entry.conclusionTime, conclusionTime__gt=0)
        abaixo = self.queryset.filter(conclusionTime__gt=entry.conclusionTime)
        qtd_acima, qtd_abaixo = min(len(acima), 50), min(len(abaixo), 50)
        
        if(len(acima) != 0):
            tempoacima = acima[len(acima)-qtd_acima].conclusionTime
        else: tempoacima = entry.conclusionTime
        
        if(len(abaixo) != 0):
            tempoabaixo = abaixo[qtd_abaixo-1].conclusionTime
        else: tempoabaixo = entry.conclusionTime
        
        maiorRank = self.queryset.filter(conclusionTime__lte=tempoacima, conclusionTime__gt=0).count()
        qs = self.queryset.filter(conclusionTime__gte=tempoacima, conclusionTime__lte=tempoabaixo)        
        return Response({"rank":maiorRank, "data":RankSerializer(qs, many=True).data})

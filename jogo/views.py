from django.shortcuts import render
from django.http import HttpResponse, HttpRequest

# Create your views here.

from rest_framework import viewsets

from .serializers import ScoreSerializer
from .models import ScoreEntry


def home(request):
    return HttpResponse("World Trucker 2020")


class ScoreViewSet(viewsets.ModelViewSet):
    queryset = ScoreEntry.objects.all().order_by('conclusionTime')
    serializer_class = ScoreSerializer
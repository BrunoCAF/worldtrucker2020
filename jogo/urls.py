# myapi/urls.py
from django.urls import include, path
from rest_framework import routers
from . import views

router = routers.DefaultRouter()
router.register(r'score_entries', views.ScoreViewSet)
router.register(r'top', views.TopScoresViewSet)
router.register(r'global', views.GlobalScoresViewSet)

urlpatterns = [
    path('', include(router.urls)),
    path('ghost', views.ghost, name='ghost'), 
    path('newuuid', views.gerarUUID, name='gerarUUID'),
    path('submit', views.submitScore, name='submit'),
    path('api-auth/', include('rest_framework.urls', namespace='rest_framework'))
]

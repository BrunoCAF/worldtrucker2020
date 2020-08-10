from django.contrib import admin

# Register your models here.
from .models import ScoreEntry

admin.site.register(ScoreEntry)
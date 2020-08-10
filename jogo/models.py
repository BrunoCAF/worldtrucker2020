from django.db import models
import uuid
# Create your models here.

class ScoreEntry(models.Model):
    username = models.CharField(max_length=60)
    userid = models.UUIDField(auto_created=True, primary_key=True, default=uuid.uuid4, editable=False)
    conclusionTime = models.FloatField(db_index=True)
    ghostInfo = models.TextField(serialize=True, max_length=1000000)

    def __str__(self):
        return self.username + ": " + str(self.conclusionTime)

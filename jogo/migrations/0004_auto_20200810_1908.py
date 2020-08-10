# Generated by Django 3.1 on 2020-08-10 19:08

from django.db import migrations, models
import uuid


class Migration(migrations.Migration):

    dependencies = [
        ('jogo', '0003_auto_20200810_1851'),
    ]

    operations = [
        migrations.AlterField(
            model_name='scoreentry',
            name='UUID',
            field=models.UUIDField(auto_created=True, default=uuid.uuid4, editable=False, primary_key=True, serialize=False),
        ),
        migrations.AlterField(
            model_name='scoreentry',
            name='conclusionTime',
            field=models.FloatField(db_index=True),
        ),
        migrations.AlterField(
            model_name='scoreentry',
            name='ghostInfo',
            field=models.TextField(max_length=1023),
        ),
    ]
# Generated by Django 3.1 on 2020-08-10 19:27

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('jogo', '0004_auto_20200810_1908'),
    ]

    operations = [
        migrations.RenameField(
            model_name='scoreentry',
            old_name='UUID',
            new_name='id',
        ),
    ]

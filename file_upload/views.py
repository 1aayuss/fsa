import os
import uuid
from django.shortcuts import render, redirect
from django.conf import settings
from django.http import HttpResponse
from django.urls import reverse

def upload_files(request):
    if request.method == 'POST':
        files = request.FILES.getlist('files')
        if files:
            folder_name = str(uuid.uuid4())
            folder_path = os.path.join(settings.MEDIA_ROOT, folder_name)
            os.makedirs(folder_path, exist_ok=True)
            
            for file in files:
                file_path = os.path.join(folder_path, file.name)
                with open(file_path, 'wb+') as destination:
                    for chunk in file.chunks():
                        destination.write(chunk)
            
            download_link = request.build_absolute_uri(reverse('file_list', args=[folder_name]))
            return render(request, 'upload_success.html', {'download_link': download_link})
    
    return render(request, 'upload_form.html')

def file_list(request, folder_name):
    folder_path = os.path.join(settings.MEDIA_ROOT, folder_name)
    files = os.listdir(folder_path)
    return render(request, 'file_list.html', {'files': files, 'folder_name': folder_name})
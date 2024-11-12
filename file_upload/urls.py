from django.urls import path
from . import views

urlpatterns = [
    path('', views.upload_files, name='upload_files'),
    path('files/<str:folder_name>/', views.file_list, name='file_list'),
]
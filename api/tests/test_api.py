import os
import sys

import pytest


CURRENT_DIR = os.path.dirname(__file__)
API_DIR = os.path.abspath(os.path.join(CURRENT_DIR, ".."))
if API_DIR not in sys.path:
    sys.path.insert(0, API_DIR)

import app as app_module  # noqa: E402


@pytest.fixture
def client():
    app_module.app.config["TESTING"] = True
    return app_module.app.test_client()


def test_post_vols_donnees_vides_retour_400(client):
    response = client.post("/api/vols", json={})
    assert response.status_code == 400
    assert response.get_json() == {"erreur": "Données invalides"}


def test_post_vols_sans_compagnie_retour_400(client):
    response = client.post("/api/vols", json={"num_vol": 123})
    assert response.status_code == 400
    assert response.get_json() == {"erreur": "Données invalides"}


def test_route_inexistante_retour_404(client):
    response = client.get("/api/inconnue")
    assert response.status_code == 404


def test_get_sur_route_delete_put_retour_405(client):
    response = client.get("/api/vols/Air%20France/442")
    assert response.status_code == 405


def test_post_aeroports_sans_json_retour_415_ou_500(client):
    response = client.post("/api/aeroports")
    assert response.status_code in (415, 500)

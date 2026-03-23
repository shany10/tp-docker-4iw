#!/bin/sh

set -eu

# Surchargable via variables d'environnement.
API_URL="${API_URL:-http://localhost:3000/api}"
TOKEN="${TOKEN:-efrei_super_pass}"

echo "Attente du service product (${API_URL}/health)..."
i=0
until curl -fsS "${API_URL}/health" >/dev/null 2>&1; do
    i=$((i + 1))
    if [ "$i" -ge 60 ]; then
        echo "Le service product n'est pas disponible après 120s"
        exit 1
    fi
    sleep 2
done

existing_products="$(curl -fsS "${API_URL}/products" || true)"
products_count="$(printf '%s' "${existing_products}" | grep -o '"_id"' | wc -l | tr -d ' ')"
if [ "${products_count}" -gt 0 ]; then
    echo "${products_count} produit(s) déjà présent(s), seed ignoré."
    exit 0
fi

create_product() {
    name="$1"
    price="$2"
    description="$3"
    stock="$4"

    curl -fsS -X POST "${API_URL}/products" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer ${TOKEN}" \
        -d "{
            \"name\": \"${name}\",
            \"price\": ${price},
            \"description\": \"${description}\",
            \"stock\": ${stock}
        }" >/dev/null
    echo "Produit créé: ${name}"
}

echo "Création des produits..."

create_product "Smartphone Galaxy S21" 899 "Dernier smartphone Samsung avec appareil photo 108MP" 15
create_product "MacBook Pro M1" 1299 "Ordinateur portable Apple avec puce M1" 10
create_product "PS5" 499 "Console de jeu dernière génération" 5
create_product "Écouteurs AirPods Pro" 249 "Écouteurs sans fil avec réduction de bruit" 20
create_product "Nintendo Switch" 299 "Console de jeu portable" 12
create_product "iPad Air" 599 "Tablette Apple avec écran Retina" 8
create_product "Montre connectée" 199 "Montre intelligente avec suivi d'activité" 25
create_product "Enceinte Bluetooth" 79 "Enceinte portable waterproof" 30

echo "Initialisation des produits terminée !"
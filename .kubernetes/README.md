# Kubernetes – Petición Firmas La Paz (frontend estático)

Manifiestos para desplegar el frontend de la petición en un cluster Kubernetes (mismo estilo que social_combat).

## Requisitos

- Cluster Kubernetes con NGINX Ingress Controller y cert-manager (si usas TLS).
- `kubectl` configurado.
- Dominio apuntando al Load Balancer del cluster.

## Estructura

```
.kubernetes/
├── 00-namespace.yaml          # Namespace firmaslapaz
├── 01-secrets.yaml            # Opcional: imagePullSecrets para registry privado
├── 02-frontend-deployment.yaml # Deployment nginx + Service
├── 03-ingress.yaml            # Ingress con TLS
└── README.md
```

## Despliegue

### 1. Build y push de la imagen

Desde la raíz del proyecto `recojida_firmas_LaPaz`:

```bash
docker build -t ghcr.io/aise17/firmaslapaz-frontend:latest .
docker push ghcr.io/aise17/firmaslapaz-frontend:latest
```

Si usas otro registry, cambia la imagen en `02-frontend-deployment.yaml`.

### 2. Configurar el dominio

Edita `03-ingress.yaml` y sustituye `firmas.lapaz.ejemplo.es` por tu dominio.

### 3. Aplicar manifiestos (en orden)

```bash
kubectl apply -f .kubernetes/00-namespace.yaml
# Solo si usas registry privado:
# kubectl apply -f .kubernetes/01-secrets.yaml
# y descomenta imagePullSecrets en 02-frontend-deployment.yaml
kubectl apply -f .kubernetes/02-frontend-deployment.yaml
kubectl apply -f .kubernetes/03-ingress.yaml
```

### 4. DNS

Apunta el host del Ingress a la IP del Load Balancer:

```
firmas.lapaz.ejemplo.es  →  A  →  <LB_IP>
```

El certificado SSL se generará con Let's Encrypt (cert-manager).

### 5. Verificación

```bash
kubectl get all,ingress -n firmaslapaz
kubectl logs deployment/frontend -n firmaslapaz
```

## Actualizar la aplicación

```bash
docker build -t ghcr.io/aise17/firmaslapaz-frontend:latest .
docker push ghcr.io/aise17/firmaslapaz-frontend:latest
kubectl rollout restart deployment/frontend -n firmaslapaz
```

## Port-forward (pruebas locales)

```bash
kubectl port-forward svc/frontend-service 8080:80 -n firmaslapaz
```

Luego abre http://localhost:8080

# provider "kubernetes" {
#   config_path = "~/.kube/config" # Path to your kubeconfig
# }

# provider "helm" {
#   kubernetes {
#     config_path = "~/.kube/config"
#   }
# }
# resource "kubernetes_namespace" "signoz" {
#   metadata {
#     name = "platform"
#   }
# }

# resource "helm_release" "signoz" {
#   name       = "signoz"
#   namespace  = kubernetes_namespace.signoz.metadata[0].name
#   repository = "https://charts.signoz.io"
#   chart      = "signoz"
#   timeout = 600
#   values = [
#     <<-EOF
#     ingress:
#       enabled: true
#       hosts:
#         - host: signoz.example.com
#           paths:
#             - path: /
#               pathType: Prefix
#     persistence:
#       enabled: true
#       storageClass: gp2
#       accessModes:
#         - ReadWriteOnce
#       size: 20Gi
#     EOF
#   ]

#   depends_on = [kubernetes_namespace.signoz]
# }


# output "signoz_dashboard_url" {
#   value = "http://signoz.example.com"
# }

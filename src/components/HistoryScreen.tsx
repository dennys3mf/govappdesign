import { useState, useEffect } from "react";
import { Button } from "./ui/button";
import { Card, CardContent } from "./ui/card";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "./ui/dialog";
import { Input } from "./ui/input";
import {
  ArrowLeft,
  FileText,
  Search,
  Calendar,
  Car,
  Building2,
  User,
  Badge,
  Clock,
  AlertTriangle,
  CheckCircle,
  XCircle,
  Eye,
} from "lucide-react";

interface HistoryScreenProps {
  onBack: () => void;
}

interface Boleta {
  id: string;
  placa: string;
  empresa: string;
  conductor: string;
  numeroLicencia: string;
  codigoFiscalizador: string;
  motivo: string;
  conforme: string;
  descripciones?: string;
  observaciones?: string;
  fecha: Date;
  inspectorId: string;
  inspectorEmail?: string;
}

export function HistoryScreen({ onBack }: HistoryScreenProps) {
  const [boletas, setBoletas] = useState<Boleta[]>([]);
  const [filteredBoletas, setFilteredBoletas] = useState<
    Boleta[]
  >([]);
  const [isLoading, setIsLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState("");
  const [selectedBoleta, setSelectedBoleta] =
    useState<Boleta | null>(null);

  // Datos simulados que representarían lo que viene de Firestore
  const mockBoletas: Boleta[] = [
    {
      id: "1",
      placa: "ABC-123",
      empresa: "Transportes El Sol S.A.",
      conductor: "Juan Carlos Pérez Rodríguez",
      numeroLicencia: "B1234567",
      codigoFiscalizador: "FISC001",
      motivo: "Transporte sin autorización municipal vigente",
      conforme: "No",
      descripciones: "Vehículo operando en ruta no autorizada",
      observaciones:
        "Conductor colaborativo, se comprometió a regularizar situación",
      fecha: new Date("2024-01-15T09:30:00"),
      inspectorId: "inspector_001",
      inspectorEmail: "inspector1@municipalidad.gob.pe",
    },
    {
      id: "2",
      placa: "DEF-456",
      empresa: "Línea Azul Express",
      conductor: "María Elena Quispe Mamani",
      numeroLicencia: "A9876543",
      codigoFiscalizador: "FISC002",
      motivo: "Falta de SOAT vigente",
      conforme: "Parcialmente",
      descripciones: "SOAT vencido hace 15 días",
      observaciones: "Presenta SOAT nuevo pero aún no vigente",
      fecha: new Date("2024-01-14T14:45:00"),
      inspectorId: "inspector_001",
      inspectorEmail: "inspector1@municipalidad.gob.pe",
    },
    {
      id: "3",
      placa: "GHI-789",
      empresa: "Transportes Rápidos Unidos",
      conductor: "Carlos Alberto Mendoza Silva",
      numeroLicencia: "B5555666",
      codigoFiscalizador: "FISC001",
      motivo: "Exceso de pasajeros",
      conforme: "No",
      descripciones:
        "Vehículo con 3 pasajeros adicionales a la capacidad permitida",
      observaciones:
        "Se solicitó descender pasajeros excedentes",
      fecha: new Date("2024-01-13T16:20:00"),
      inspectorId: "inspector_001",
      inspectorEmail: "inspector1@municipalidad.gob.pe",
    },
    {
      id: "4",
      placa: "JKL-012",
      empresa: "Empresa de Transportes La Victoria",
      conductor: "Ana Beatriz Huamán Torres",
      numeroLicencia: "A1111222",
      codigoFiscalizador: "FISC003",
      motivo: "Revisión técnica vencida",
      conforme: "Sí",
      descripciones: "Revisión técnica vencida por 2 días",
      observaciones:
        "Conductor presenta nueva cita para revisión técnica",
      fecha: new Date("2024-01-12T11:15:00"),
      inspectorId: "inspector_002",
      inspectorEmail: "inspector2@municipalidad.gob.pe",
    },
    {
      id: "5",
      placa: "MNO-345",
      empresa: "Transportes Metropolitanos del Sur",
      conductor: "Roberto José Fernández López",
      numeroLicencia: "B7777888",
      codigoFiscalizador: "FISC001",
      motivo: "Alteración de ruta autorizada",
      conforme: "No",
      descripciones:
        "Desviación de ruta sin autorización previa",
      observaciones:
        "Conductor argumenta desvío por obras en vía principal",
      fecha: new Date("2024-01-11T08:50:00"),
      inspectorId: "inspector_001",
      inspectorEmail: "inspector1@municipalidad.gob.pe",
    },
  ];

  useEffect(() => {
    // Simular carga desde Firestore
    const loadBoletas = async () => {
      setIsLoading(true);
      await new Promise((resolve) => setTimeout(resolve, 1500));

      // Ordenar por fecha descendente (más recientes primero)
      const sortedBoletas = mockBoletas.sort(
        (a, b) => b.fecha.getTime() - a.fecha.getTime(),
      );
      setBoletas(sortedBoletas);
      setFilteredBoletas(sortedBoletas);
      setIsLoading(false);
    };

    loadBoletas();
  }, []);

  useEffect(() => {
    // Filtrar boletas según término de búsqueda
    if (searchTerm.trim() === "") {
      setFilteredBoletas(boletas);
    } else {
      const filtered = boletas.filter(
        (boleta) =>
          boleta.placa
            .toLowerCase()
            .includes(searchTerm.toLowerCase()) ||
          boleta.empresa
            .toLowerCase()
            .includes(searchTerm.toLowerCase()) ||
          boleta.conductor
            .toLowerCase()
            .includes(searchTerm.toLowerCase()),
      );
      setFilteredBoletas(filtered);
    }
  }, [searchTerm, boletas]);

  const formatDate = (date: Date) => {
    return new Intl.DateTimeFormat("es-PE", {
      day: "2-digit",
      month: "2-digit",
      year: "2-digit",
    }).format(date);
  };

  const formatDateTime = (date: Date) => {
    return new Intl.DateTimeFormat("es-PE", {
      day: "2-digit",
      month: "2-digit",
      year: "numeric",
      hour: "2-digit",
      minute: "2-digit",
      hour12: false,
    }).format(date);
  };

  const getConformeIcon = (conforme: string) => {
    switch (conforme.toLowerCase()) {
      case "sí":
        return (
          <CheckCircle className="w-4 h-4 text-emerald-600" />
        );
      case "no":
        return <XCircle className="w-4 h-4 text-red-600" />;
      case "parcialmente":
        return (
          <AlertTriangle className="w-4 h-4 text-amber-600" />
        );
      default:
        return (
          <AlertTriangle className="w-4 h-4 text-gray-600" />
        );
    }
  };

  const getConformeColor = (conforme: string) => {
    switch (conforme.toLowerCase()) {
      case "sí":
        return "text-emerald-600 bg-emerald-50";
      case "no":
        return "text-red-600 bg-red-50";
      case "parcialmente":
        return "text-amber-600 bg-amber-50";
      default:
        return "text-gray-600 bg-gray-50";
    }
  };

  if (isLoading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-primary/5 via-red-50/50 to-primary/10">
        <header className="bg-white/80 backdrop-blur-lg border-b border-primary/10 sticky top-0 z-50">
          <div className="max-w-4xl mx-auto px-6 py-4 flex items-center justify-between">
            <div className="flex items-center space-x-4">
              <Button
                variant="ghost"
                onClick={onBack}
                className="flex items-center space-x-2 text-muted-foreground hover:text-foreground rounded-2xl"
              >
                <ArrowLeft className="w-5 h-5" />
              </Button>
              <h1 className="text-primary tracking-tight">
                Historial de Boletas
              </h1>
            </div>
          </div>
        </header>

        <div className="flex items-center justify-center min-h-[60vh]">
          <div className="flex flex-col items-center space-y-4">
            <div className="w-8 h-8 border-2 border-primary/30 border-t-primary rounded-full animate-spin"></div>
            <p className="text-muted-foreground">
              Cargando historial...
            </p>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-primary/5 via-red-50/50 to-primary/10">
      {/* Header */}
      <header className="bg-white/80 backdrop-blur-lg border-b border-primary/10 sticky top-0 z-50">
        <div className="max-w-4xl mx-auto px-6 py-4 flex items-center justify-between">
          <div className="flex items-center space-x-4">
            <Button
              variant="ghost"
              onClick={onBack}
              className="flex items-center space-x-2 text-muted-foreground hover:text-foreground rounded-2xl"
            >
              <ArrowLeft className="w-5 h-5" />
            </Button>
            <h1 className="text-primary tracking-tight">
              Historial de Boletas
            </h1>
          </div>

          {/* Search */}
          <div className="flex-1 max-w-md mx-8">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-muted-foreground" />
              <Input
                placeholder="Buscar por placa, empresa o conductor..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="pl-10 h-10 bg-white/60 border-0 rounded-2xl focus:bg-white transition-colors"
              />
            </div>
          </div>

          <div className="text-sm text-muted-foreground">
            {filteredBoletas.length} boleta
            {filteredBoletas.length !== 1 ? "s" : ""}
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-4xl mx-auto px-6 py-8">
        {filteredBoletas.length === 0 ? (
          <div className="text-center py-16">
            <FileText className="w-16 h-16 text-muted-foreground/50 mx-auto mb-6" />
            <h3 className="text-foreground mb-2">
              {searchTerm
                ? "No se encontraron resultados"
                : "No hay boletas guardadas"}
            </h3>
            <p className="text-muted-foreground">
              {searchTerm
                ? "Intenta con otros términos de búsqueda"
                : "Las boletas emitidas aparecerán aquí"}
            </p>
          </div>
        ) : (
          <div className="space-y-4">
            {filteredBoletas.map((boleta, index) => (
              <Dialog key={boleta.id}>
                <DialogTrigger asChild>
                  <Card className="border-0 shadow-lg shadow-primary/10 rounded-3xl overflow-hidden cursor-pointer hover:shadow-xl hover:shadow-primary/15 transition-all duration-300 hover:scale-[1.01] bg-white">
                    <CardContent className="p-6">
                      <div className="flex items-center justify-between">
                        <div className="flex items-center space-x-4">
                          <div className="w-12 h-12 bg-gradient-to-br from-primary/20 to-red-600/20 rounded-2xl flex items-center justify-center">
                            <span className="text-primary font-medium">
                              {index + 1}
                            </span>
                          </div>
                          <div className="flex-1">
                            <div className="flex items-center space-x-3 mb-2">
                              <h3 className="text-foreground font-medium">
                                Placa:{" "}
                                {boleta.placa.toUpperCase()}
                              </h3>
                              <div
                                className={`px-3 py-1 rounded-full text-xs font-medium flex items-center space-x-1 ${getConformeColor(boleta.conforme)}`}
                              >
                                {getConformeIcon(
                                  boleta.conforme,
                                )}
                                <span>{boleta.conforme}</span>
                              </div>
                            </div>
                            <p className="text-muted-foreground text-sm">
                              {boleta.empresa}
                            </p>
                            <div className="flex items-center space-x-4 mt-2 text-xs text-muted-foreground">
                              <div className="flex items-center space-x-1">
                                <User className="w-3 h-3" />
                                <span>{boleta.conductor}</span>
                              </div>
                              <div className="flex items-center space-x-1">
                                <Badge className="w-3 h-3" />
                                <span>
                                  {boleta.codigoFiscalizador}
                                </span>
                              </div>
                            </div>
                          </div>
                        </div>

                        <div className="flex items-center space-x-4">
                          <div className="text-right">
                            <div className="flex items-center space-x-1 text-muted-foreground text-sm">
                              <Calendar className="w-4 h-4" />
                              <span>
                                {formatDate(boleta.fecha)}
                              </span>
                            </div>
                            <div className="flex items-center space-x-1 text-muted-foreground text-xs mt-1">
                              <Clock className="w-3 h-3" />
                              <span>
                                {boleta.fecha.toLocaleTimeString(
                                  "es-PE",
                                  {
                                    hour: "2-digit",
                                    minute: "2-digit",
                                  },
                                )}
                              </span>
                            </div>
                          </div>
                          <Eye className="w-5 h-5 text-muted-foreground" />
                        </div>
                      </div>
                    </CardContent>
                  </Card>
                </DialogTrigger>

                <DialogContent className="max-w-2xl max-h-[80vh] overflow-y-auto rounded-3xl">
                  <DialogHeader>
                    <DialogTitle className="flex items-center space-x-3">
                      <FileText className="w-6 h-6 text-primary" />
                      <span>
                        Detalles de Boleta #{index + 1}
                      </span>
                    </DialogTitle>
                    <DialogDescription>
                      Información completa de la boleta de
                      fiscalización emitida
                    </DialogDescription>
                  </DialogHeader>

                  <div className="space-y-6 mt-6">
                    {/* Información del Vehículo */}
                    <div className="space-y-3">
                      <h4 className="text-foreground font-medium flex items-center space-x-2">
                        <Car className="w-4 h-4 text-primary" />
                        <span>Información del Vehículo</span>
                      </h4>
                      <div className="grid grid-cols-2 gap-4 pl-6">
                        <div>
                          <p className="text-sm text-muted-foreground">
                            Placa
                          </p>
                          <p className="font-medium">
                            {boleta.placa.toUpperCase()}
                          </p>
                        </div>
                        <div>
                          <p className="text-sm text-muted-foreground">
                            Empresa
                          </p>
                          <p className="font-medium">
                            {boleta.empresa}
                          </p>
                        </div>
                      </div>
                    </div>

                    {/* Información del Conductor */}
                    <div className="space-y-3">
                      <h4 className="text-foreground font-medium flex items-center space-x-2">
                        <User className="w-4 h-4 text-primary" />
                        <span>Información del Conductor</span>
                      </h4>
                      <div className="grid grid-cols-2 gap-4 pl-6">
                        <div>
                          <p className="text-sm text-muted-foreground">
                            Conductor
                          </p>
                          <p className="font-medium">
                            {boleta.conductor}
                          </p>
                        </div>
                        <div>
                          <p className="text-sm text-muted-foreground">
                            N° Licencia
                          </p>
                          <p className="font-medium">
                            {boleta.numeroLicencia}
                          </p>
                        </div>
                      </div>
                    </div>

                    {/* Información de la Fiscalización */}
                    <div className="space-y-3">
                      <h4 className="text-foreground font-medium flex items-center space-x-2">
                        <AlertTriangle className="w-4 h-4 text-primary" />
                        <span>Detalles de Fiscalización</span>
                      </h4>
                      <div className="space-y-4 pl-6">
                        <div>
                          <p className="text-sm text-muted-foreground">
                            Fecha y Hora
                          </p>
                          <p className="font-medium">
                            {formatDateTime(boleta.fecha)}
                          </p>
                        </div>
                        <div>
                          <p className="text-sm text-muted-foreground">
                            Fiscalizador
                          </p>
                          <p className="font-medium">
                            {boleta.codigoFiscalizador}
                          </p>
                        </div>
                        <div>
                          <p className="text-sm text-muted-foreground">
                            Motivo
                          </p>
                          <p className="font-medium">
                            {boleta.motivo}
                          </p>
                        </div>
                        <div>
                          <p className="text-sm text-muted-foreground">
                            Conforme
                          </p>
                          <div
                            className={`inline-flex items-center space-x-2 px-3 py-1 rounded-full text-sm font-medium ${getConformeColor(boleta.conforme)}`}
                          >
                            {getConformeIcon(boleta.conforme)}
                            <span>{boleta.conforme}</span>
                          </div>
                        </div>
                        {boleta.descripciones && (
                          <div>
                            <p className="text-sm text-muted-foreground">
                              Descripciones
                            </p>
                            <p className="font-medium">
                              {boleta.descripciones}
                            </p>
                          </div>
                        )}
                        {boleta.observaciones && (
                          <div>
                            <p className="text-sm text-muted-foreground">
                              Observaciones
                            </p>
                            <p className="font-medium">
                              {boleta.observaciones}
                            </p>
                          </div>
                        )}
                      </div>
                    </div>
                  </div>
                </DialogContent>
              </Dialog>
            ))}
          </div>
        )}
      </main>
    </div>
  );
}
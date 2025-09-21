import { useState } from 'react';
import { Button } from './ui/button';
import { Card, CardContent, CardHeader, CardTitle } from './ui/card';
import { Badge } from './ui/badge';
import { Avatar, AvatarFallback } from './ui/avatar';
import { Progress } from './ui/progress';
import { Tabs, TabsContent, TabsList, TabsTrigger } from './ui/tabs';
import { Input } from './ui/input';
import { Textarea } from './ui/textarea';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from './ui/select';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from './ui/dialog';
import { AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent, AlertDialogDescription, AlertDialogFooter, AlertDialogHeader, AlertDialogTitle, AlertDialogTrigger } from './ui/alert-dialog';
import { Label } from './ui/label';
import { 
  LogOut,
  Plus,
  Edit,
  Trash2,
  Eye,
  Download,
  Search,
  Filter,
  Users,
  FileText,
  TrendingUp,
  Calendar,
  CheckCircle,
  XCircle,
  AlertTriangle,
  Camera,
  Save,
  X,
  BarChart3,
  Settings,
  Shield,
  ZoomIn,
  ImageIcon,
  Maximize2,
  Info
} from 'lucide-react';
import laJoyaLogo from 'figma:asset/573ae69949bb1650d02f03b6b86b01620a91b133.png';

interface AdminDashboardProps {
  onLogout: () => void;
  userName?: string;
}

interface Boleta {
  id: string;
  placa: string;
  empresa: string;
  conductor: string;
  numeroLicencia: string;
  fiscalizador: string;
  motivo: string;
  conforme: 'Sí' | 'No' | 'Parcialmente';
  fecha: Date;
  fotoLicencia?: string;
  descripciones?: string;
  observaciones?: string;
  multa?: number;
  estado: 'Activa' | 'Pagada' | 'Anulada';
}

interface Inspector {
  id: string;
  nombre: string;
  codigo: string;
  email: string;
  telefono: string;
  estado: 'Activo' | 'Inactivo';
  fechaIngreso: Date;
  boletas: number;
  conformes: number;
  noConformes: number;
  ultimaActividad: Date;
}

// Mock data expandido
const mockBoletas: Boleta[] = [
  {
    id: '1',
    placa: 'ABC-123',
    empresa: 'Transportes San Martín',
    conductor: 'Juan Carlos Pérez',
    numeroLicencia: 'B123456789',
    fiscalizador: 'FISC001',
    motivo: 'Revisión rutinaria de documentos',
    conforme: 'Sí',
    fecha: new Date('2024-01-15T10:30:00'),
    fotoLicencia: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&h=300&fit=crop',
    descripciones: 'Documentación completa y en regla',
    multa: 0,
    estado: 'Activa'
  },
  {
    id: '2',
    placa: 'DEF-456',
    empresa: 'Express Arequipa',
    conductor: 'María Elena Rodriguez',
    numeroLicencia: 'B987654321',
    fiscalizador: 'FISC002',
    motivo: 'Verificación de licencia vencida',
    conforme: 'No',
    fecha: new Date('2024-01-15T11:45:00'),
    fotoLicencia: 'https://images.unsplash.com/photo-1558618047-3c8c76ca7d13?w=400&h=300&fit=crop',
    observaciones: 'Licencia vencida desde hace 3 meses',
    multa: 850.00,
    estado: 'Activa'
  },
  {
    id: '3',
    placa: 'GHI-789',
    empresa: 'Turismo La Joya',
    conductor: 'Carlos Alberto Mendoza',
    numeroLicencia: 'B456789123',
    fiscalizador: 'FISC001',
    motivo: 'Control de seguridad vehicular',
    conforme: 'Parcialmente',
    fecha: new Date('2024-01-15T14:20:00'),
    fotoLicencia: 'https://images.unsplash.com/photo-1597223557154-721c1cecc4b0?w=400&h=300&fit=crop',
    descripciones: 'Licencia válida pero falta certificado de revisión técnica',
    multa: 425.00,
    estado: 'Pagada'
  },
  {
    id: '4',
    placa: 'JKL-012',
    empresa: 'Servicios Unidos',
    conductor: 'Ana Patricia Flores',
    numeroLicencia: 'B789123456',
    fiscalizador: 'FISC003',
    motivo: 'Inspección de documentos de carga',
    conforme: 'Sí',
    fecha: new Date('2024-01-15T16:10:00'),
    fotoLicencia: 'https://images.unsplash.com/photo-1494790108755-2616c045c7d3?w=400&h=300&fit=crop',
    descripciones: 'Todo en orden, documentación completa',
    multa: 0,
    estado: 'Activa'
  },
  {
    id: '5',
    placa: 'MNO-345',
    empresa: 'Transportes del Sur',
    conductor: 'Roberto Silva Vargas',
    numeroLicencia: 'B321654987',
    fiscalizador: 'FISC002',
    motivo: 'Verificación de permisos especiales',
    conforme: 'No',
    fecha: new Date('2024-01-14T09:15:00'),
    fotoLicencia: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=300&fit=crop',
    observaciones: 'Falta permiso para transporte de pasajeros',
    multa: 750.00,
    estado: 'Activa'
  },
  {
    id: '6',
    placa: 'PQR-678',
    empresa: 'Turismo Regional',
    conductor: 'Carmen Rosa Gutiérrez',
    numeroLicencia: 'B654321098',
    fiscalizador: 'FISC001',
    motivo: 'Control de rutina',
    conforme: 'Sí',
    fecha: new Date('2024-01-14T14:30:00'),
    fotoLicencia: 'https://images.unsplash.com/photo-1607746882042-944635dfe10e?w=400&h=300&fit=crop',
    descripciones: 'Licencia vigente, documentos en orden',
    multa: 0,
    estado: 'Activa'
  },
  {
    id: '7',
    placa: 'STU-901',
    empresa: 'Express Lima',
    conductor: 'Miguel Ángel Torres',
    numeroLicencia: 'B098765432',
    fiscalizador: 'FISC003',
    motivo: 'Verificación de documentos',
    conforme: 'Parcialmente',
    fecha: new Date('2024-01-14T11:20:00'),
    fotoLicencia: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=300&fit=crop',
    descripciones: 'Licencia válida, falta certificado médico actualizado',
    multa: 200.00,
    estado: 'Pagada'
  },
  {
    id: '8',
    placa: 'VWX-234',
    empresa: 'Carga Pesada SAC',
    conductor: 'Luis Alberto Ramírez',
    numeroLicencia: 'B567890123',
    fiscalizador: 'FISC002',
    motivo: 'Inspección de carga',
    conforme: 'No',
    fecha: new Date('2024-01-13T08:45:00'),
    fotoLicencia: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&h=300&fit=crop',
    observaciones: 'Licencia para categoría incorrecta',
    multa: 1200.00,
    estado: 'Anulada'
  }
];

const mockInspectores: Inspector[] = [
  {
    id: 'FISC001',
    nombre: 'Carlos Mendoza',
    codigo: 'FISC001',
    email: 'c.mendoza@lajoya.gob.pe',
    telefono: '+51 987 654 321',
    estado: 'Activo',
    fechaIngreso: new Date('2023-06-15'),
    boletas: 15,
    conformes: 12,
    noConformes: 3,
    ultimaActividad: new Date('2024-01-15T16:45:00')
  },
  {
    id: 'FISC002',
    nombre: 'Ana Rodriguez',
    codigo: 'FISC002',
    email: 'a.rodriguez@lajoya.gob.pe',
    telefono: '+51 987 654 322',
    estado: 'Activo',
    fechaIngreso: new Date('2023-03-10'),
    boletas: 22,
    conformes: 18,
    noConformes: 4,
    ultimaActividad: new Date('2024-01-15T15:20:00')
  },
  {
    id: 'FISC003',
    nombre: 'Miguel Torres',
    codigo: 'FISC003',
    email: 'm.torres@lajoya.gob.pe',
    telefono: '+51 987 654 323',
    estado: 'Inactivo',
    fechaIngreso: new Date('2023-08-20'),
    boletas: 8,
    conformes: 6,
    noConformes: 2,
    ultimaActividad: new Date('2024-01-10T14:10:00')
  }
];

export function AdminDashboard({ onLogout, userName = "Administrador" }: AdminDashboardProps) {
  const [boletas, setBoletas] = useState<Boleta[]>(mockBoletas);
  const [inspectores, setInspectores] = useState<Inspector[]>(mockInspectores);
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedInspector, setSelectedInspector] = useState<string>('all');
  const [selectedStatus, setSelectedStatus] = useState<string>('all');
  const [isCreateDialogOpen, setIsCreateDialogOpen] = useState(false);
  const [isEditDialogOpen, setIsEditDialogOpen] = useState(false);
  const [editingBoleta, setEditingBoleta] = useState<Boleta | null>(null);
  const [isCreateInspectorDialogOpen, setIsCreateInspectorDialogOpen] = useState(false);
  const [isEditInspectorDialogOpen, setIsEditInspectorDialogOpen] = useState(false);
  const [editingInspector, setEditingInspector] = useState<Inspector | null>(null);
  const [selectedPhoto, setSelectedPhoto] = useState<Boleta | null>(null);
  const [isPhotoViewerOpen, setIsPhotoViewerOpen] = useState(false);
  const [photoSearchTerm, setPhotoSearchTerm] = useState('');
  const [photoFilterInspector, setPhotoFilterInspector] = useState<string>('all');
  const [photoFilterConforme, setPhotoFilterConforme] = useState<string>('all');

  // Estados para formularios
  const [formData, setFormData] = useState<Partial<Boleta>>({});
  const [inspectorFormData, setInspectorFormData] = useState<Partial<Inspector>>({});

  // Estadísticas calculadas
  const totalBoletas = boletas.length;
  const totalConformes = boletas.filter(b => b.conforme === 'Sí').length;
  const totalNoConformes = boletas.filter(b => b.conforme === 'No').length;
  const totalParciales = boletas.filter(b => b.conforme === 'Parcialmente').length;
  const porcentajeConformidad = totalBoletas > 0 ? Math.round((totalConformes / totalBoletas) * 100) : 0;
  const totalInspectores = inspectores.length;
  const inspectoresActivos = inspectores.filter(i => i.estado === 'Activo').length;
  const totalMultas = boletas.reduce((sum, b) => sum + (b.multa || 0), 0);
  const totalFotos = boletas.filter(b => b.fotoLicencia).length;

  // Filtros
  const filteredBoletas = boletas.filter(boleta => {
    const matchesSearch = 
      boleta.placa.toLowerCase().includes(searchTerm.toLowerCase()) ||
      boleta.empresa.toLowerCase().includes(searchTerm.toLowerCase()) ||
      boleta.conductor.toLowerCase().includes(searchTerm.toLowerCase()) ||
      boleta.fiscalizador.toLowerCase().includes(searchTerm.toLowerCase());
    
    const matchesInspector = selectedInspector === 'all' || boleta.fiscalizador === selectedInspector;
    const matchesStatus = selectedStatus === 'all' || boleta.estado === selectedStatus;
    
    return matchesSearch && matchesInspector && matchesStatus;
  });

  // Filtros para fotos
  const filteredPhotos = boletas.filter(boleta => {
    // Solo mostrar boletas que tienen foto
    if (!boleta.fotoLicencia) return false;
    
    const matchesSearch = 
      boleta.placa.toLowerCase().includes(photoSearchTerm.toLowerCase()) ||
      boleta.empresa.toLowerCase().includes(photoSearchTerm.toLowerCase()) ||
      boleta.conductor.toLowerCase().includes(photoSearchTerm.toLowerCase()) ||
      boleta.fiscalizador.toLowerCase().includes(photoSearchTerm.toLowerCase());
    
    const matchesInspector = photoFilterInspector === 'all' || boleta.fiscalizador === photoFilterInspector;
    const matchesConforme = photoFilterConforme === 'all' || boleta.conforme === photoFilterConforme;
    
    return matchesSearch && matchesInspector && matchesConforme;
  });

  const getConformeColor = (conforme: string) => {
    switch (conforme) {
      case 'Sí': return 'bg-green-100 text-green-800';
      case 'No': return 'bg-red-100 text-red-800';
      case 'Parcialmente': return 'bg-yellow-100 text-yellow-800';
      default: return 'bg-gray-100 text-gray-800';
    }
  };

  const getEstadoColor = (estado: string) => {
    switch (estado) {
      case 'Activa': return 'bg-blue-100 text-blue-800';
      case 'Pagada': return 'bg-green-100 text-green-800';
      case 'Anulada': return 'bg-red-100 text-red-800';
      default: return 'bg-gray-100 text-gray-800';
    }
  };

  const getConformeIcon = (conforme: string) => {
    switch (conforme) {
      case 'Sí': return <CheckCircle className="w-4 h-4" />;
      case 'No': return <XCircle className="w-4 h-4" />;
      case 'Parcialmente': return <AlertTriangle className="w-4 h-4" />;
      default: return null;
    }
  };

  const handleCreateBoleta = () => {
    const newBoleta: Boleta = {
      id: Date.now().toString(),
      ...formData as Boleta,
      fecha: new Date(),
      estado: 'Activa'
    };
    setBoletas([newBoleta, ...boletas]);
    setFormData({});
    setIsCreateDialogOpen(false);
  };

  const handleEditBoleta = () => {
    if (editingBoleta) {
      setBoletas(boletas.map(b => 
        b.id === editingBoleta.id 
          ? { ...editingBoleta, ...formData }
          : b
      ));
      setEditingBoleta(null);
      setFormData({});
      setIsEditDialogOpen(false);
    }
  };

  const handleDeleteBoleta = (id: string) => {
    setBoletas(boletas.filter(b => b.id !== id));
  };

  const handleCreateInspector = () => {
    const newInspector: Inspector = {
      id: Date.now().toString(),
      ...inspectorFormData as Inspector,
      fechaIngreso: new Date(),
      boletas: 0,
      conformes: 0,
      noConformes: 0,
      ultimaActividad: new Date(),
      estado: 'Activo'
    };
    setInspectores([...inspectores, newInspector]);
    setInspectorFormData({});
    setIsCreateInspectorDialogOpen(false);
  };

  const handleEditInspector = () => {
    if (editingInspector) {
      setInspectores(inspectores.map(i => 
        i.id === editingInspector.id 
          ? { ...editingInspector, ...inspectorFormData }
          : i
      ));
      setEditingInspector(null);
      setInspectorFormData({});
      setIsEditInspectorDialogOpen(false);
    }
  };

  const handleDeleteInspector = (id: string) => {
    setInspectores(inspectores.filter(i => i.id !== id));
  };

  const handlePhotoClick = (boleta: Boleta) => {
    setSelectedPhoto(boleta);
    setIsPhotoViewerOpen(true);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-primary/5 via-red-50/50 to-primary/10">
      {/* Header */}
      <header className="bg-white/80 backdrop-blur-lg border-b border-primary/10 sticky top-0 z-50">
        <div className="max-w-7xl mx-auto px-6 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-4">
              <div className="flex items-center space-x-3">
                <div className="w-10 h-6 bg-white rounded-xl flex items-center justify-center p-1 shadow-sm">
                  <img 
                    src={laJoyaLogo} 
                    alt="La Joya" 
                    className="w-full h-full object-contain"
                  />
                </div>
                <div>
                  <h1 className="text-primary tracking-tight">Panel Administrativo</h1>
                  <p className="text-sm text-muted-foreground">Gestión de Fiscalización - {userName}</p>
                </div>
              </div>
            </div>
            <div className="flex items-center space-x-3">
              <Badge variant="secondary" className="bg-green-100 text-green-800">
                <Shield className="w-3 h-3 mr-1" />
                Administrador
              </Badge>
              <Button variant="outline" className="rounded-2xl">
                <Download className="w-4 h-4 mr-2" />
                Exportar
              </Button>
              <Button
                variant="ghost"
                onClick={onLogout}
                className="rounded-2xl text-muted-foreground hover:text-foreground"
              >
                <LogOut className="w-4 h-4" />
              </Button>
            </div>
          </div>
        </div>
      </header>

      <main className="max-w-7xl mx-auto px-6 py-8">
        {/* Stats Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-6 gap-4 mb-8">
          <Card className="border-0 shadow-lg shadow-primary/10 rounded-3xl bg-gradient-to-br from-white to-blue-50/30">
            <CardContent className="p-4">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-xs text-muted-foreground mb-1">Total Boletas</p>
                  <p className="text-2xl text-primary tracking-tight">{totalBoletas}</p>
                </div>
                <div className="w-10 h-10 bg-gradient-to-br from-blue-500 to-blue-600 rounded-2xl flex items-center justify-center">
                  <FileText className="w-5 h-5 text-white" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="border-0 shadow-lg shadow-primary/10 rounded-3xl bg-gradient-to-br from-white to-green-50/30">
            <CardContent className="p-4">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-xs text-muted-foreground mb-1">Conformes</p>
                  <p className="text-2xl text-green-600 tracking-tight">{totalConformes}</p>
                </div>
                <div className="w-10 h-10 bg-gradient-to-br from-green-500 to-green-600 rounded-2xl flex items-center justify-center">
                  <CheckCircle className="w-5 h-5 text-white" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="border-0 shadow-lg shadow-primary/10 rounded-3xl bg-gradient-to-br from-white to-red-50/30">
            <CardContent className="p-4">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-xs text-muted-foreground mb-1">No Conformes</p>
                  <p className="text-2xl text-red-600 tracking-tight">{totalNoConformes}</p>
                </div>
                <div className="w-10 h-10 bg-gradient-to-br from-red-500 to-red-600 rounded-2xl flex items-center justify-center">
                  <XCircle className="w-5 h-5 text-white" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="border-0 shadow-lg shadow-primary/10 rounded-3xl bg-gradient-to-br from-white to-purple-50/30">
            <CardContent className="p-4">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-xs text-muted-foreground mb-1">Inspectores</p>
                  <p className="text-2xl text-purple-600 tracking-tight">{inspectoresActivos}/{totalInspectores}</p>
                </div>
                <div className="w-10 h-10 bg-gradient-to-br from-purple-500 to-purple-600 rounded-2xl flex items-center justify-center">
                  <Users className="w-5 h-5 text-white" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="border-0 shadow-lg shadow-primary/10 rounded-3xl bg-gradient-to-br from-white to-orange-50/30">
            <CardContent className="p-4">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-xs text-muted-foreground mb-1">Total Multas</p>
                  <p className="text-xl text-orange-600 tracking-tight">S/ {totalMultas.toFixed(0)}</p>
                </div>
                <div className="w-10 h-10 bg-gradient-to-br from-orange-500 to-orange-600 rounded-2xl flex items-center justify-center">
                  <TrendingUp className="w-5 h-5 text-white" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="border-0 shadow-lg shadow-primary/10 rounded-3xl bg-gradient-to-br from-white to-teal-50/30">
            <CardContent className="p-4">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-xs text-muted-foreground mb-1">Fotos Licencias</p>
                  <p className="text-2xl text-teal-600 tracking-tight">{totalFotos}</p>
                </div>
                <div className="w-10 h-10 bg-gradient-to-br from-teal-500 to-teal-600 rounded-2xl flex items-center justify-center">
                  <Camera className="w-5 h-5 text-white" />
                </div>
              </div>  
            </CardContent>
          </Card>
        </div>

        <Tabs defaultValue="boletas" className="space-y-6">
          <TabsList className="grid w-full grid-cols-4 bg-white rounded-2xl p-1 shadow-sm">
            <TabsTrigger value="boletas" className="rounded-xl">Gestión de Boletas</TabsTrigger>
            <TabsTrigger value="fotos" className="rounded-xl">Fotos de Licencias</TabsTrigger>
            <TabsTrigger value="inspectores" className="rounded-xl">Gestión de Inspectores</TabsTrigger>
            <TabsTrigger value="reportes" className="rounded-xl">Reportes y Análisis</TabsTrigger>
          </TabsList>

          {/* Gestión de Boletas */}
          <TabsContent value="boletas" className="space-y-6">
            {/* Filtros y Acciones */}
            <Card className="border-0 shadow-lg shadow-primary/10 rounded-3xl">
              <CardContent className="p-6">
                <div className="flex flex-col lg:flex-row gap-4 items-start lg:items-center justify-between">
                  <div className="flex flex-col md:flex-row gap-4 flex-1">
                    <div className="relative flex-1">
                      <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                      <Input
                        placeholder="Buscar por placa, empresa, conductor..."
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                        className="pl-10 rounded-2xl"
                      />
                    </div>
                    <Select value={selectedInspector} onValueChange={setSelectedInspector}>
                      <SelectTrigger className="w-full md:w-48 rounded-2xl">
                        <SelectValue placeholder="Filtrar por inspector" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="all">Todos los inspectores</SelectItem>
                        {inspectores.map((inspector) => (
                          <SelectItem key={inspector.id} value={inspector.codigo}>
                            {inspector.nombre}
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                    <Select value={selectedStatus} onValueChange={setSelectedStatus}>
                      <SelectTrigger className="w-full md:w-48 rounded-2xl">
                        <SelectValue placeholder="Filtrar por estado" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="all">Todos los estados</SelectItem>
                        <SelectItem value="Activa">Activa</SelectItem>
                        <SelectItem value="Pagada">Pagada</SelectItem>
                        <SelectItem value="Anulada">Anulada</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                  <Button className="bg-gradient-to-r from-primary to-red-600 text-white rounded-2xl shadow-lg">
                    <Plus className="w-4 h-4 mr-2" />
                    Nueva Boleta
                  </Button>
                </div>
              </CardContent>
            </Card>

            {/* Lista de Boletas */}
            <Card className="border-0 shadow-lg shadow-primary/10 rounded-3xl">
              <CardContent className="p-6">
                <div className="space-y-4">
                  {filteredBoletas.map((boleta) => (
                    <div key={boleta.id} className="p-4 bg-muted/30 rounded-2xl hover:bg-muted/50 transition-colors">
                      <div className="flex items-center justify-between mb-3">
                        <div className="flex items-center space-x-3">
                          <div className="w-8 h-8 bg-primary/10 rounded-xl flex items-center justify-center">
                            <FileText className="w-4 h-4 text-primary" />
                          </div>
                          <div>
                            <h4 className="text-sm">Placa: {boleta.placa}</h4>
                            <p className="text-xs text-muted-foreground">{boleta.empresa}</p>
                          </div>
                        </div>
                        <div className="flex items-center space-x-2">
                          <Badge className={getConformeColor(boleta.conforme)}>
                            {getConformeIcon(boleta.conforme)}
                            <span className="ml-1">{boleta.conforme}</span>
                          </Badge>
                          <Badge className={getEstadoColor(boleta.estado)}>
                            {boleta.estado}
                          </Badge>
                          <div className="flex space-x-1">
                            <Button variant="ghost" size="sm" className="rounded-xl h-8 w-8 p-0">
                              <Eye className="w-4 h-4" />
                            </Button>
                            <Button variant="ghost" size="sm" className="rounded-xl h-8 w-8 p-0">
                              <Edit className="w-4 h-4" />
                            </Button>
                            <Button variant="ghost" size="sm" className="rounded-xl h-8 w-8 p-0 text-red-600 hover:text-red-700 hover:bg-red-50">
                              <Trash2 className="w-4 h-4" />
                            </Button>
                          </div>
                        </div>
                      </div>
                      
                      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4 text-xs">
                        <div>
                          <span className="text-muted-foreground">Conductor:</span>
                          <p className="truncate">{boleta.conductor}</p>
                        </div>
                        <div>
                          <span className="text-muted-foreground">Licencia:</span>
                          <p>{boleta.numeroLicencia}</p>
                        </div>
                        <div>
                          <span className="text-muted-foreground">Inspector:</span>
                          <p>{boleta.fiscalizador}</p>
                        </div>
                        <div>
                          <span className="text-muted-foreground">Fecha:</span>
                          <p>{boleta.fecha.toLocaleString('es-PE', {
                            day: '2-digit',
                            month: '2-digit',
                            hour: '2-digit',
                            minute: '2-digit'
                          })}</p>
                        </div>
                        <div>
                          <span className="text-muted-foreground">Multa:</span>
                          <p className={boleta.multa && boleta.multa > 0 ? 'text-red-600' : 'text-green-600'}>
                            {boleta.multa && boleta.multa > 0 ? `S/ ${boleta.multa.toFixed(2)}` : 'Sin multa'}
                          </p>
                        </div>
                      </div>
                      
                      <div className="mt-3 pt-3 border-t border-border">
                        <p className="text-xs text-muted-foreground mb-1">Motivo:</p>
                        <p className="text-xs">{boleta.motivo}</p>
                        {boleta.fotoLicencia && (
                          <div className="mt-2">
                            <Button
                              variant="outline"
                              size="sm"
                              onClick={() => handlePhotoClick(boleta)}
                              className="rounded-xl text-xs"
                            >
                              <Camera className="w-3 h-3 mr-1" />
                              Ver Foto de Licencia
                            </Button>
                          </div>
                        )}
                      </div>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          </TabsContent>

          {/* Fotos de Licencias */}
          <TabsContent value="fotos" className="space-y-6">
            {/* Filtros para Fotos */}
            <Card className="border-0 shadow-lg shadow-primary/10 rounded-3xl">
              <CardHeader>
                <CardTitle className="flex items-center space-x-2">
                  <Camera className="w-5 h-5 text-primary" />
                  <span>Galería de Fotos de Licencias</span>
                  <Badge variant="secondary" className="ml-2">
                    {filteredPhotos.length} fotos
                  </Badge>
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="flex flex-col md:flex-row gap-4">
                  <div className="relative flex-1">
                    <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                    <Input
                      placeholder="Buscar por placa, conductor, empresa..."
                      value={photoSearchTerm}
                      onChange={(e) => setPhotoSearchTerm(e.target.value)}
                      className="pl-10 rounded-2xl"
                    />
                  </div>
                  <Select value={photoFilterInspector} onValueChange={setPhotoFilterInspector}>
                    <SelectTrigger className="w-full md:w-48 rounded-2xl">
                      <SelectValue placeholder="Filtrar por inspector" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="all">Todos los inspectores</SelectItem>
                      {inspectores.map((inspector) => (
                        <SelectItem key={inspector.id} value={inspector.codigo}>
                          {inspector.nombre}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                  <Select value={photoFilterConforme} onValueChange={setPhotoFilterConforme}>
                    <SelectTrigger className="w-full md:w-48 rounded-2xl">
                      <SelectValue placeholder="Filtrar por conformidad" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="all">Todas las conformidades</SelectItem>
                      <SelectItem value="Sí">Conforme</SelectItem>
                      <SelectItem value="No">No Conforme</SelectItem>
                      <SelectItem value="Parcialmente">Parcialmente</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
              </CardContent>
            </Card>

            {/* Galería de Fotos */}
            <Card className="border-0 shadow-lg shadow-primary/10 rounded-3xl">
              <CardContent className="p-6">
                {filteredPhotos.length > 0 ? (
                  <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                    {filteredPhotos.map((boleta) => (
                      <div key={boleta.id} className="bg-white rounded-2xl overflow-hidden shadow-sm hover:shadow-lg transition-all duration-300 hover:scale-[1.02]">
                        <div className="aspect-[4/3] relative group cursor-pointer" onClick={() => handlePhotoClick(boleta)}>
                          <img
                            src={boleta.fotoLicencia}
                            alt={`Licencia de ${boleta.conductor}`}
                            className="w-full h-full object-cover"
                          />
                          <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
                          <div className="absolute inset-0 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                            <div className="bg-white/90 rounded-full p-3">
                              <ZoomIn className="w-6 h-6 text-primary" />
                            </div>
                          </div>
                          <div className="absolute top-2 right-2">
                            <Badge className={`${getConformeColor(boleta.conforme)} shadow-sm`}>
                              {getConformeIcon(boleta.conforme)}
                              <span className="ml-1">{boleta.conforme}</span>
                            </Badge>
                          </div>
                          <div className="absolute top-2 left-2">
                            <Badge className={`${getEstadoColor(boleta.estado)} shadow-sm`}>
                              {boleta.estado}
                            </Badge>
                          </div>
                        </div>
                        <div className="p-4">
                          <h4 className="text-sm mb-2 truncate">{boleta.conductor}</h4>
                          <div className="space-y-1 text-xs text-muted-foreground">
                            <div className="flex justify-between">
                              <span>Placa:</span>
                              <span className="text-foreground">{boleta.placa}</span>
                            </div>
                            <div className="flex justify-between">
                              <span>Licencia:</span>
                              <span className="text-foreground">{boleta.numeroLicencia}</span>
                            </div>
                            <div className="flex justify-between">
                              <span>Inspector:</span>
                              <span className="text-foreground">{boleta.fiscalizador}</span>
                            </div>
                            <div className="flex justify-between">
                              <span>Fecha:</span>
                              <span className="text-foreground">
                                {boleta.fecha.toLocaleDateString('es-PE', {
                                  day: '2-digit',
                                  month: '2-digit',
                                  year: '2-digit'
                                })}
                              </span>
                            </div>
                            <div className="flex justify-between">
                              <span>Empresa:</span>
                              <span className="text-foreground truncate ml-2">{boleta.empresa}</span>
                            </div>
                          </div>
                          <div className="mt-3 pt-3 border-t border-border">
                            <Button
                              variant="outline"
                              size="sm"
                              onClick={() => handlePhotoClick(boleta)}
                              className="w-full rounded-xl text-xs"
                            >
                              <Eye className="w-3 h-3 mr-1" />
                              Ver Detalles
                            </Button>
                          </div>
                        </div>
                      </div>
                    ))}
                  </div>
                ) : (
                  <div className="text-center py-12">
                    <Camera className="w-16 h-16 text-muted-foreground mx-auto mb-4" />
                    <h4 className="text-muted-foreground mb-2">No se encontraron fotos</h4>
                    <p className="text-sm text-muted-foreground">
                      No hay fotos de licencias que coincidan con los filtros seleccionados
                    </p>
                  </div>
                )}
              </CardContent>
            </Card>
          </TabsContent>

          {/* Gestión de Inspectores */}
          <TabsContent value="inspectores" className="space-y-6">
            <Card className="border-0 shadow-lg shadow-primary/10 rounded-3xl">
              <CardHeader>
                <div className="flex justify-between items-center">
                  <CardTitle className="flex items-center space-x-2">
                    <Users className="w-5 h-5 text-primary" />
                    <span>Gestión de Inspectores</span>
                  </CardTitle>
                  <Button className="bg-gradient-to-r from-primary to-red-600 text-white rounded-2xl shadow-lg">
                    <Plus className="w-4 h-4 mr-2" />
                    Nuevo Inspector
                  </Button>
                </div>
              </CardHeader>
              <CardContent>
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                  {inspectores.map((inspector) => (
                    <div key={inspector.id} className="p-6 bg-muted/30 rounded-2xl">
                      <div className="flex items-center justify-between mb-4">
                        <div className="flex items-center space-x-3">
                          <Avatar className="w-12 h-12">
                            <AvatarFallback className="bg-primary text-white">
                              {inspector.nombre.split(' ').map(n => n[0]).join('')}
                            </AvatarFallback>
                          </Avatar>
                          <div>
                            <h3 className="text-sm">{inspector.nombre}</h3>
                            <p className="text-xs text-muted-foreground">{inspector.codigo}</p>
                          </div>
                        </div>
                        <Badge className={inspector.estado === 'Activo' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}>
                          {inspector.estado}
                        </Badge>
                      </div>
                      
                      <div className="space-y-2 mb-4">
                        <div className="flex justify-between items-center text-xs">
                          <span className="text-muted-foreground">Email:</span>
                          <span className="truncate ml-2">{inspector.email}</span>
                        </div>
                        <div className="flex justify-between items-center text-xs">
                          <span className="text-muted-foreground">Teléfono:</span>
                          <span>{inspector.telefono}</span>
                        </div>
                        <div className="flex justify-between items-center text-xs">
                          <span className="text-muted-foreground">Boletas:</span>
                          <span>{inspector.boletas}</span>
                        </div>
                        <div className="flex justify-between items-center text-xs">
                          <span className="text-muted-foreground">Conformes:</span>
                          <span className="text-green-600">{inspector.conformes}</span>
                        </div>
                        <div className="flex justify-between items-center text-xs">
                          <span className="text-muted-foreground">No Conformes:</span>
                          <span className="text-red-600">{inspector.noConformes}</span>
                        </div>
                      </div>

                      <div className="pt-2 mb-4">
                        <div className="flex justify-between items-center mb-1">
                          <span className="text-xs text-muted-foreground">Tasa de Conformidad</span>
                          <span className="text-xs">{inspector.boletas > 0 ? Math.round((inspector.conformes/inspector.boletas)*100) : 0}%</span>
                        </div>
                        <Progress value={inspector.boletas > 0 ? (inspector.conformes/inspector.boletas)*100 : 0} className="h-1" />
                      </div>

                      <div className="flex justify-end space-x-1">
                        <Button variant="ghost" size="sm" className="rounded-xl h-8 w-8 p-0">
                          <Edit className="w-4 h-4" />
                        </Button>
                        <Button variant="ghost" size="sm" className="rounded-xl h-8 w-8 p-0 text-red-600 hover:text-red-700 hover:bg-red-50">
                          <Trash2 className="w-4 h-4" />
                        </Button>
                      </div>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          </TabsContent>

          {/* Reportes y Análisis */}
          <TabsContent value="reportes" className="space-y-6">
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
              {/* Gráfico de Conformidad */}
              <Card className="border-0 shadow-lg shadow-primary/10 rounded-3xl">
                <CardHeader>
                  <CardTitle className="flex items-center space-x-2">
                    <BarChart3 className="w-5 h-5 text-primary" />
                    <span>Distribución de Conformidad</span>
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    <div className="flex items-center justify-between">
                      <div className="flex items-center space-x-2">
                        <div className="w-3 h-3 bg-green-500 rounded-full"></div>
                        <span className="text-sm">Conforme</span>
                      </div>
                      <span className="text-sm">{totalConformes} ({totalBoletas > 0 ? Math.round((totalConformes/totalBoletas)*100) : 0}%)</span>
                    </div>
                    <Progress value={totalBoletas > 0 ? (totalConformes/totalBoletas)*100 : 0} className="h-2" />
                    
                    <div className="flex items-center justify-between">
                      <div className="flex items-center space-x-2">
                        <div className="w-3 h-3 bg-red-500 rounded-full"></div>
                        <span className="text-sm">No Conforme</span>
                      </div>
                      <span className="text-sm">{totalNoConformes} ({totalBoletas > 0 ? Math.round((totalNoConformes/totalBoletas)*100) : 0}%)</span>
                    </div>
                    <Progress value={totalBoletas > 0 ? (totalNoConformes/totalBoletas)*100 : 0} className="h-2" />
                    
                    <div className="flex items-center justify-between">
                      <div className="flex items-center space-x-2">
                        <div className="w-3 h-3 bg-yellow-500 rounded-full"></div>
                        <span className="text-sm">Parcialmente</span>
                      </div>
                      <span className="text-sm">{totalParciales} ({totalBoletas > 0 ? Math.round((totalParciales/totalBoletas)*100) : 0}%)</span>
                    </div>
                    <Progress value={totalBoletas > 0 ? (totalParciales/totalBoletas)*100 : 0} className="h-2" />
                  </div>
                </CardContent>
              </Card>

              {/* Estadísticas de Multas */}
              <Card className="border-0 shadow-lg shadow-primary/10 rounded-3xl">
                <CardHeader>
                  <CardTitle className="flex items-center space-x-2">
                    <TrendingUp className="w-5 h-5 text-primary" />
                    <span>Estadísticas de Multas</span>
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    <div className="flex items-center justify-between p-3 bg-red-50 rounded-2xl">
                      <span className="text-sm">Total Recaudado</span>
                      <span className="text-lg text-red-600">S/ {totalMultas.toFixed(2)}</span>
                    </div>
                    <div className="flex items-center justify-between p-3 bg-blue-50 rounded-2xl">
                      <span className="text-sm">Multas Activas</span>
                      <span className="text-lg text-blue-600">{boletas.filter(b => b.estado === 'Activa' && b.multa && b.multa > 0).length}</span>
                    </div>
                    <div className="flex items-center justify-between p-3 bg-green-50 rounded-2xl">
                      <span className="text-sm">Multas Pagadas</span>
                      <span className="text-lg text-green-600">{boletas.filter(b => b.estado === 'Pagada' && b.multa && b.multa > 0).length}</span>
                    </div>
                    <div className="flex items-center justify-between p-3 bg-orange-50 rounded-2xl">
                      <span className="text-sm">Promedio por Multa</span>
                      <span className="text-lg text-orange-600">
                        S/ {boletas.filter(b => b.multa && b.multa > 0).length > 0 
                          ? (totalMultas / boletas.filter(b => b.multa && b.multa > 0).length).toFixed(2)
                          : '0.00'
                        }
                      </span>
                    </div>
                  </div>
                </CardContent>
              </Card>
            </div>
          </TabsContent>
        </Tabs>

        {/* Modal Visor de Fotos */}
        <Dialog open={isPhotoViewerOpen} onOpenChange={setIsPhotoViewerOpen}>
          <DialogContent className="max-w-4xl max-h-[90vh] p-0">
            <DialogHeader className="p-6 pb-4">
              <DialogTitle className="flex items-center space-x-2">
                <Camera className="w-5 h-5 text-primary" />
                <span>Licencia de Conducir - {selectedPhoto?.conductor}</span>
              </DialogTitle>
            </DialogHeader>
            {selectedPhoto && (
              <div className="px-6 pb-6">
                {/* Imagen Principal */}
                <div className="mb-6">
                  <div className="relative bg-gray-100 rounded-2xl overflow-hidden">
                    <img
                      src={selectedPhoto.fotoLicencia}
                      alt={`Licencia de ${selectedPhoto.conductor}`}
                      className="w-full h-auto max-h-96 object-contain"
                    />
                    <div className="absolute top-4 right-4 flex space-x-2">
                      <Badge className={getConformeColor(selectedPhoto.conforme)}>
                        {getConformeIcon(selectedPhoto.conforme)}
                        <span className="ml-1">{selectedPhoto.conforme}</span>
                      </Badge>
                      <Badge className={getEstadoColor(selectedPhoto.estado)}>
                        {selectedPhoto.estado}
                      </Badge>
                    </div>
                  </div>
                </div>

                {/* Información Detallada */}
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  {/* Datos del Conductor */}
                  <Card className="border border-border/50">
                    <CardHeader className="pb-3">
                      <CardTitle className="text-base flex items-center space-x-2">
                        <Info className="w-4 h-4" />
                        <span>Información del Conductor</span>
                      </CardTitle>
                    </CardHeader>
                    <CardContent className="space-y-3">
                      <div>
                        <label className="text-sm text-muted-foreground">Nombre Completo</label>
                        <p className="text-sm">{selectedPhoto.conductor}</p>
                      </div>
                      <div>
                        <label className="text-sm text-muted-foreground">Número de Licencia</label>
                        <p className="text-sm">{selectedPhoto.numeroLicencia}</p>
                      </div>
                      <div>
                        <label className="text-sm text-muted-foreground">Empresa</label>
                        <p className="text-sm">{selectedPhoto.empresa}</p>
                      </div>
                      <div>
                        <label className="text-sm text-muted-foreground">Placa del Vehículo</label>
                        <p className="text-sm">{selectedPhoto.placa}</p>
                      </div>
                    </CardContent>
                  </Card>

                  {/* Datos de la Fiscalización */}
                  <Card className="border border-border/50">
                    <CardHeader className="pb-3">
                      <CardTitle className="text-base flex items-center space-x-2">
                        <FileText className="w-4 h-4" />
                        <span>Información de la Fiscalización</span>
                      </CardTitle>
                    </CardHeader>
                    <CardContent className="space-y-3">
                      <div>
                        <label className="text-sm text-muted-foreground">Inspector</label>
                        <p className="text-sm">{selectedPhoto.fiscalizador}</p>
                      </div>
                      <div>
                        <label className="text-sm text-muted-foreground">Fecha y Hora</label>
                        <p className="text-sm">
                          {selectedPhoto.fecha.toLocaleString('es-PE', {
                            day: '2-digit',
                            month: '2-digit',
                            year: 'numeric',
                            hour: '2-digit',
                            minute: '2-digit'
                          })}
                        </p>
                      </div>
                      <div>
                        <label className="text-sm text-muted-foreground">Estado de la Boleta</label>
                        <Badge className={getEstadoColor(selectedPhoto.estado)}>
                          {selectedPhoto.estado}
                        </Badge>
                      </div>
                      <div>
                        <label className="text-sm text-muted-foreground">Conformidad</label>
                        <Badge className={getConformeColor(selectedPhoto.conforme)}>
                          {getConformeIcon(selectedPhoto.conforme)}
                          <span className="ml-1">{selectedPhoto.conforme}</span>
                        </Badge>
                      </div>
                      {selectedPhoto.multa && selectedPhoto.multa > 0 && (
                        <div>
                          <label className="text-sm text-muted-foreground">Monto de Multa</label>
                          <p className="text-sm text-red-600">S/ {selectedPhoto.multa.toFixed(2)}</p>
                        </div>
                      )}
                    </CardContent>
                  </Card>
                </div>

                {/* Motivo y Observaciones */}
                <div className="mt-6 space-y-4">
                  <div>
                    <label className="text-sm text-muted-foreground">Motivo de la Fiscalización</label>
                    <p className="text-sm mt-1 p-3 bg-muted/30 rounded-xl">{selectedPhoto.motivo}</p>
                  </div>
                  {selectedPhoto.descripciones && (
                    <div>
                      <label className="text-sm text-muted-foreground">Descripciones</label>
                      <p className="text-sm mt-1 p-3 bg-blue-50 rounded-xl">{selectedPhoto.descripciones}</p>
                    </div>
                  )}
                  {selectedPhoto.observaciones && (
                    <div>
                      <label className="text-sm text-muted-foreground">Observaciones</label>
                      <p className="text-sm mt-1 p-3 bg-red-50 rounded-xl text-red-800">{selectedPhoto.observaciones}</p>
                    </div>
                  )}
                </div>

                {/* Acciones */}
                <div className="mt-6 flex justify-end space-x-3">
                  <Button variant="outline" className="rounded-2xl">
                    <Download className="w-4 h-4 mr-2" />
                    Descargar Foto
                  </Button>
                  <Button 
                    onClick={() => setIsPhotoViewerOpen(false)}
                    className="bg-gradient-to-r from-primary to-red-600 text-white rounded-2xl"
                  >
                    Cerrar
                  </Button>
                </div>
              </div>
            )}
          </DialogContent>
        </Dialog>
      </main>
    </div>
  );
}
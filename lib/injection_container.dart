import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'core/network/api_client.dart';
import 'data/datasources/brand_remote_data_source.dart';
import 'data/datasources/store_remote_data_source.dart';
import 'data/datasources/supplier_remote_data_source.dart';
import 'data/datasources/product_remote_data_source.dart';
import 'data/repositories/brand_repository_impl.dart';
import 'data/repositories/store_repository_impl.dart';
import 'data/repositories/supplier_repository_impl.dart';
import 'data/repositories/product_repository_impl.dart';
import 'domain/repositories/brand_repository.dart';
import 'domain/repositories/store_repository.dart';
import 'domain/repositories/supplier_repository.dart';
import 'domain/repositories/product_repository.dart';
import 'domain/usecases/brand/get_all_brands_usecase.dart';
import 'domain/usecases/brand/get_brand_by_id_usecase.dart';
import 'domain/usecases/brand/create_brand_usecase.dart';
import 'domain/usecases/brand/update_brand_usecase.dart';
import 'domain/usecases/brand/delete_brand_usecase.dart';
import 'domain/usecases/store/get_all_stores_usecase.dart';
import 'domain/usecases/store/get_store_by_id_usecase.dart';
import 'domain/usecases/store/create_store_usecase.dart';
import 'domain/usecases/store/update_store_usecase.dart';
import 'domain/usecases/store/delete_store_usecase.dart';
import 'domain/usecases/supplier/get_all_suppliers_usecase.dart';
import 'domain/usecases/supplier/get_supplier_by_id_usecase.dart';
import 'domain/usecases/supplier/create_supplier_usecase.dart';
import 'domain/usecases/supplier/update_supplier_usecase.dart';
import 'domain/usecases/supplier/delete_supplier_usecase.dart';
import 'domain/usecases/product/get_all_products_usecase.dart';
import 'domain/usecases/product/get_product_by_id_usecase.dart';
import 'domain/usecases/product/create_product_usecase.dart';
import 'domain/usecases/product/update_product_usecase.dart';
import 'domain/usecases/product/delete_product_usecase.dart';
import 'domain/usecases/product/search_products_usecase.dart';
import 'domain/usecases/product/create_store_quantity_usecase.dart';
import 'domain/usecases/product/update_store_quantity_usecase.dart';
import 'presentation/admin/provider/brand_provider.dart';
import 'presentation/admin/provider/store_provider.dart';
import 'presentation/admin/provider/supplier_provider.dart';
import 'presentation/admin/provider/product_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => ApiClient(dio: Dio()));

  // Data source
  sl.registerLazySingleton(() => BrandRemoteDataSource(sl()));
  sl.registerLazySingleton(() => StoreRemoteDataSource(sl()));
  sl.registerLazySingleton(() => SupplierRemoteDataSource(sl()));
  sl.registerLazySingleton(() => ProductRemoteDataSource(sl()));

  // Repository
  sl.registerLazySingleton<BrandRepository>(() => BrandRepositoryImpl(sl()));
  sl.registerLazySingleton<StoreRepository>(() => StoreRepositoryImpl(sl()));
  sl.registerLazySingleton<SupplierRepository>(() => SupplierRepositoryImpl(sl()));
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(sl()));

  // Usecases
  sl.registerLazySingleton(() => GetAllBrandsUseCase(sl()));
  sl.registerLazySingleton(() => GetBrandByIdUseCase(sl()));
  sl.registerLazySingleton(() => CreateBrandUseCase(sl()));
  sl.registerLazySingleton(() => UpdateBrandUseCase(sl()));
  sl.registerLazySingleton(() => DeleteBrandUseCase(sl()));
  sl.registerLazySingleton(() => GetAllStoresUseCase(sl()));
  sl.registerLazySingleton(() => GetStoreByIdUseCase(sl()));
  sl.registerLazySingleton(() => CreateStoreUseCase(sl()));
  sl.registerLazySingleton(() => UpdateStoreUseCase(sl()));
  sl.registerLazySingleton(() => DeleteStoreUseCase(sl()));
  sl.registerLazySingleton(() => GetAllSuppliersUseCase(sl()));
  sl.registerLazySingleton(() => GetSupplierByIdUseCase(sl()));
  sl.registerLazySingleton(() => CreateSupplierUseCase(sl()));
  sl.registerLazySingleton(() => UpdateSupplierUseCase(sl()));
  sl.registerLazySingleton(() => DeleteSupplierUseCase(sl()));
  sl.registerLazySingleton(() => GetAllProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetProductByIdUseCase(sl()));
  sl.registerLazySingleton(() => CreateProductUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProductUseCase(sl()));
  sl.registerLazySingleton(() => DeleteProductUseCase(sl()));
  sl.registerLazySingleton(() => SearchProductsUseCase(sl()));
  sl.registerLazySingleton(() => CreateStoreQuantityUseCase(sl()));
  sl.registerLazySingleton(() => UpdateStoreQuantityUseCase(sl()));

  // Provider: register factory so each provider instance created by provider package is new if needed
  sl.registerFactory(() => BrandProvider(
        getAllUseCase: sl(),
        getByIdUseCase: sl(),
        createUseCase: sl(),
        updateUseCase: sl(),
        deleteUseCase: sl(),
      ));
  sl.registerFactory(() => StoreProvider(
        getAllUseCase: sl(),
        getByIdUseCase: sl(),
        createUseCase: sl(),
        updateUseCase: sl(),
        deleteUseCase: sl(),
      ));
  sl.registerFactory(() => SupplierProvider(
        getAllUseCase: sl(),
        getByIdUseCase: sl(),
        createUseCase: sl(),
        updateUseCase: sl(),
        deleteUseCase: sl(),
      ));
  sl.registerFactory(() => ProductProvider(
        getAllUseCase: sl(),
        getByIdUseCase: sl(),
        createUseCase: sl(),
        updateUseCase: sl(),
        deleteUseCase: sl(),
        searchUseCase: sl(),
        createStoreQuantityUseCase: sl(),
        updateStoreQuantityUseCase: sl(),
      ));
}

declare module "@salesforce/apex/ProductController.getProducts" {
  export default function getProducts(param: {filters: any, pageNumber: any}): Promise<any>;
}
declare module "@salesforce/apex/ProductController.getSimilarProducts" {
  export default function getSimilarProducts(param: {productId: any, familyId: any}): Promise<any>;
}

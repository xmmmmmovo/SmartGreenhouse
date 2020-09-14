export const isExternal = (path: string) => /^(https?:|mailto:|tel:)/.test(path)

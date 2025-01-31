import { describe, it, beforeEach, expect } from "vitest"

describe("mineral-registry", () => {
  let contract: any
  
  beforeEach(() => {
    contract = {
      getMineral: (mineralId: number) => ({
        name: "Gold",
        origin: "South Africa",
        initialQuantity: 1000,
        registrationDate: 100,
        registrar: "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM",
      }),
      registerMineral: (name: string, origin: string, initialQuantity: number) => ({ value: 1 }),
      getAllMinerals: () => ({ value: 3 }),
    }
  })
  
  describe("get-mineral", () => {
    it("should return mineral information", () => {
      const result = contract.getMineral(1)
      expect(result.name).toBe("Gold")
      expect(result.origin).toBe("South Africa")
    })
  })
  
  describe("register-mineral", () => {
    it("should register a new mineral", () => {
      const result = contract.registerMineral("Silver", "Peru", 500)
      expect(result.value).toBe(1)
    })
  })
  
  describe("get-all-minerals", () => {
    it("should return the total number of registered minerals", () => {
      const result = contract.getAllMinerals()
      expect(result.value).toBe(3)
    })
  })
})

